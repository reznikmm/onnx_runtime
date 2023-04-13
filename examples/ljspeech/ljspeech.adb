--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Ada.Streams.Stream_IO;
with Interfaces;

with ONNX_Runtime.Environments;
with ONNX_Runtime.Sessions;
with ONNX_Runtime.Values;

procedure ljSpeech is

   procedure Write_Wave
      (Name : String;
       Wave : ONNX_Runtime.Values.Float_Array);
   --  Write `.wav` file with given Name and Wave by converting Float to int16

   ----------------
   -- Write_Wave --
   ----------------

   procedure Write_Wave
      (Name : String;
       Wave : ONNX_Runtime.Values.Float_Array)
   is
      File : Ada.Streams.Stream_IO.File_Type;
      Stream : Ada.Streams.Stream_IO.Stream_Access;
   begin
      Ada.Streams.Stream_IO.Create (File, Name => Name);
      Stream := Ada.Streams.Stream_IO.Stream (File);
      String'Write (Stream, "RIFF");
      Integer'Write (Stream, 36 + 2 * Wave'Length);
      String'Write (Stream, "WAVEfmt ");
      Integer'Write (Stream, 16);
      Interfaces.Unsigned_16'Write (Stream, 1);  --  PCM format
      --  Interfaces.Unsigned_16'Write (Stream, 3);  --  Float format
      Interfaces.Unsigned_16'Write (Stream, 1);  --  1 channel
      Integer'Write (Stream, 22050);  --  Rate
      Integer'Write (Stream, 2 * 22050);  --  Byte rate
      Interfaces.Unsigned_16'Write (Stream, 2);  --  Bytes per block
      Interfaces.Unsigned_16'Write (Stream, 16);  --  Bits per sample
      String'Write (Stream, "data");
      Integer'Write (Stream, 2 * Wave'Length);

      for X of Wave loop
         Interfaces.Integer_16'Write
          (Stream, Interfaces.Integer_16 (2.0**15 * X));
      end loop;
   end Write_Wave;

   Tokens : constant ONNX_Runtime.Values.Int64_Array :=
     (4, 15, 10,  6,  4,  4, 28,  4, 34, 10,  2,  3, 51, 11);
   --  Text converted to tokens by TTSTokenizer

   Env : constant ONNX_Runtime.Environments.Environment :=
     ONNX_Runtime.Environments.Create_Environment;

   Session : ONNX_Runtime.Sessions.Session :=
     Env.Create_Session (Model => "model.onnx");
   --  https://huggingface.co/NeuML/ljspeech-jets-onnx

   Output : ONNX_Runtime.Values.Value_Array (1 .. 2);
   Input  : constant ONNX_Runtime.Values.Value_Array (1 .. 1) :=
     (1 => ONNX_Runtime.Values.Create_Tensor (Tokens, (1 => Tokens'Length)));

begin
   Session.Run (Input, Output);

   declare
      Length : constant ONNX_Runtime.Values.Element_Index := Output (1).Length;
      Wave : ONNX_Runtime.Values.Float_Array (1 .. Length);
   begin
      Output (1).Get_Data (Wave);
      Write_Wave ("test.wav", Wave);
   end;
end ljSpeech;
