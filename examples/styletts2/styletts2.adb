--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

--  StyleTTS2 single-speaker demo: ONNX Runtime inference from Ada.
--
--  Usage:
--    styletts2_demo MODEL.onnx STYLE.bin OUTPUT.wav [TOKEN,TOKEN,...]
--  Without the last argument the demo uses the token ids of "мі́ст".
--
--  STYLE.bin is the raw data file of style.pt (256 float32, little endian),
--  i.e. the "data/0" entry of the unzipped archive.

pragma Ada_2022;

with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Streams;            use Ada.Streams;
with Ada.Streams.Stream_IO;
with Ada.Text_IO;
with Interfaces;

with ONNX_Runtime.Environments;
with ONNX_Runtime.Sessions;
with ONNX_Runtime.Values;

procedure StyleTTS2 is

   use type ONNX_Runtime.Values.Element_Index;
   use type Stream_Element;

   Sample_Rate  : constant := 24_000;
   Style_Length : constant := 256;

   subtype Style_Vector is ONNX_Runtime.Values.Float_Array (1 .. Style_Length);

   --  Token ids for "мі́ст" (IPA "ˈmʲist"); see config.yml vocabulary.
   --  Note: the BOS token 0 is added by the graph itself and must not be here.
   Default_Tokens : constant ONNX_Runtime.Values.Int64_Array :=
     (171, 62, 179, 58, 68, 69);

   --  Parses "171,62,179" into an Int64_Array.
   function Parse_Tokens (Text : String) return ONNX_Runtime.Values.Int64_Array is
      Count : ONNX_Runtime.Values.Element_Index := 1;
   begin
      for C of Text loop
         if C = ',' then
            Count := Count + 1;
         end if;
      end loop;
      declare
         Result : ONNX_Runtime.Values.Int64_Array (1 .. Count);
         Index  : ONNX_Runtime.Values.Element_Index := 1;
         Start  : Positive := Text'First;
      begin
         for I in Text'Range loop
            if Text (I) = ',' or else I = Text'Last then
               declare
                  Last : constant Positive := (if Text (I) = ',' then I - 1 else I);
               begin
                  Result (Index) := Interfaces.Integer_64'Value (Text (Start .. Last));
                  Index := Index + 1;
               end;
               Start := I + 1;
            end if;
         end loop;
         return Result;
      end;
   end Parse_Tokens;

   Speed : constant ONNX_Runtime.Values.Float_Array := (1 => 1.0);

   --  Rank-0 (scalar) shape for "speed".
   No_Shape : constant ONNX_Runtime.Values.Element_Index_Array (1 .. 0) := [];

   --  Reads 256 float32 values from the raw style file.
   --  Float'Read uses the machine representation, which is little endian
   --  on the usual x86_64/aarch64 targets.
   function Read_Style (Path : String) return Style_Vector is
      File   : Ada.Streams.Stream_IO.File_Type;
      Result : Style_Vector;
   begin
      Ada.Streams.Stream_IO.Open (File, Ada.Streams.Stream_IO.In_File, Path);
      declare
         Stream : constant Ada.Streams.Stream_IO.Stream_Access :=
           Ada.Streams.Stream_IO.Stream (File);
      begin
         for I in Result'Range loop
            Float'Read (Stream, Result (I));
         end loop;
      end;
      Ada.Streams.Stream_IO.Close (File);
      return Result;
   end Read_Style;

   --  Writes mono 16-bit PCM WAV at Sample_Rate.
   procedure Write_Wav (Path : String; Samples : ONNX_Runtime.Values.Float_Array) is
      use Interfaces;

      File       : Ada.Streams.Stream_IO.File_Type;
      Data_Bytes : constant Unsigned_32 := Unsigned_32 (Samples'Length * 2);

      procedure Put_Bytes (Value : Unsigned_32; Count : Positive) is
         Bytes : Stream_Element_Array (1 .. Stream_Element_Offset (Count));
      begin
         for I in Bytes'Range loop
            Bytes (I) :=
              Stream_Element (Shift_Right (Value, 8 * (Integer (I) - 1)) and 16#FF#);
         end loop;
         Ada.Streams.Stream_IO.Write (File, Bytes);
      end Put_Bytes;

      procedure Put_Text (Text : String) is
         Bytes : Stream_Element_Array (1 .. Stream_Element_Offset (Text'Length));
      begin
         for I in Text'Range loop
            Bytes (Stream_Element_Offset (I - Text'First + 1)) :=
              Stream_Element (Character'Pos (Text (I)));
         end loop;
         Ada.Streams.Stream_IO.Write (File, Bytes);
      end Put_Text;
   begin
      Ada.Streams.Stream_IO.Create (File, Ada.Streams.Stream_IO.Out_File, Path);

      Put_Text ("RIFF");
      Put_Bytes (36 + Data_Bytes, 4);
      Put_Text ("WAVE");
      Put_Text ("fmt ");
      Put_Bytes (16, 4);                        --  fmt chunk size
      Put_Bytes (1, 2);                         --  PCM
      Put_Bytes (1, 2);                         --  mono
      Put_Bytes (Unsigned_32 (Sample_Rate), 4);
      Put_Bytes (Unsigned_32 (Sample_Rate * 2), 4);  --  byte rate
      Put_Bytes (2, 2);                         --  block align
      Put_Bytes (16, 2);                        --  bits per sample
      Put_Text ("data");
      Put_Bytes (Data_Bytes, 4);

      for S of Samples loop
         declare
            Clamped : constant Float := Float'Max (-1.0, Float'Min (1.0, S));
            Value   : constant Integer := Integer (Float'Rounding (Clamped * 32_767.0));
         begin
            Put_Bytes (Unsigned_32 (Value mod 65_536), 2);
         end;
      end loop;

      Ada.Streams.Stream_IO.Close (File);
   end Write_Wav;

   Model_Path  : constant String := Ada.Command_Line.Argument (1);
   Style_Path  : constant String := Ada.Command_Line.Argument (2);
   Output_Path : constant String := Ada.Command_Line.Argument (3);

   S_Prev : constant Style_Vector := Read_Style (Style_Path);

   Tokens : constant ONNX_Runtime.Values.Int64_Array :=
     (if Ada.Command_Line.Argument_Count = 4
      then Parse_Tokens (Ada.Command_Line.Argument (4))
      else Default_Tokens);

begin
   if Ada.Command_Line.Argument_Count not in 3 | 4 then
      Ada.Text_IO.Put_Line
        ("usage: styletts2_demo MODEL.onnx STYLE.bin OUTPUT.wav [TOKEN,TOKEN,...]");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   declare
      Env : constant ONNX_Runtime.Environments.Environment :=
        ONNX_Runtime.Environments.Create_Environment;

      Session : ONNX_Runtime.Sessions.Session :=
        Env.Create_Session (Model => Model_Path);

      --  Inputs must be in the graph's order: tokens, speed, s_prev.
      Input : constant ONNX_Runtime.Values.Value_Array (1 .. 3) :=
        (1 => ONNX_Runtime.Values.Create_Tensor (Tokens, (1 => Tokens'Length)),
         2 => ONNX_Runtime.Values.Create_Tensor (Speed, No_Shape),
         3 => ONNX_Runtime.Values.Create_Tensor (S_Prev, (1, Style_Length)));

      Output : ONNX_Runtime.Values.Value_Array (1 .. 1);
   begin
      Session.Run (Input, Output);

      declare
         Length : constant ONNX_Runtime.Values.Element_Index := Output (1).Length;
         Wave   : ONNX_Runtime.Values.Float_Array (1 .. Length);
      begin
         Output (1).Get_Data (Wave);
         Write_Wav (Output_Path, Wave);
         Ada.Text_IO.Put_Line
           ("wrote" & Length'Image & " samples," &
            Float'Image (Float (Length) / Float (Sample_Rate)) & " s to " & Output_Path);
      end;
   end;

exception
   when E : others =>
      Ada.Text_IO.Put_Line ("error: " & Ada.Exceptions.Exception_Message (E));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end StyleTTS2;
