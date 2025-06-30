--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--                          2025 Nerd Type <N>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Ada.Float_Text_IO;
with Ada.Text_IO;
with Ada.Unchecked_Conversion;

with ONNX_Runtime.Environments;
with ONNX_Runtime.Sessions;
with ONNX_Runtime.Values; use ONNX_Runtime.Values;
with SDL; use SDL;
with SDL.Events.Events;
with SDL.Events.Mice; use SDL.Events.Mice;
with SDL.Inputs.Mice;
with SDL.Video;
with SDL.Video.Pixels;
with SDL.Video.Pixel_Formats;
with SDL.Video.Renderers.Makers;
with SDL.Video.Textures.Makers;
with SDL.Video.Windows; use SDL.Video.Windows;
with SDL.Video.Windows.Makers;
with System;

procedure MNIST_SDL is

   SDL_Error : exception;

   SDL_Flags     : constant SDL.Init_Flags := Enable_Everything;
   Renderer_Flag : constant SDL.Video.Renderers.Renderer_Flags
                            := SDL.Video.Renderers.Accelerated;

   Shutdown  : Boolean := False;
   New_Input : Boolean := True;

   type Texture_Array is array (SDL.Dimension range <>, SDL.Dimension range <>)
         of aliased SDL.Video.Pixels.ARGB_8888;
   procedure Lock is new SDL.Video.Textures.Lock
         (Pixel_Pointer_Type => SDL.Video.Pixels.ARGB_8888_Access.Pointer);

   Event     : SDL.Events.Events.Events;
   Window    : SDL.Video.Windows.Window;
   Pixels    : SDL.Video.Pixels.ARGB_8888_Access.Pointer;
   Renderer  : SDL.Video.Renderers.Renderer;
   Texture   : SDL.Video.Textures.Texture;

   type Mouse_Button_State_Type is (Button_Up, Button_Down);
   Mouse_Button_State : Mouse_Button_State_Type := Button_Up;

   o : constant Float := 0.0;
   X : constant Float := 1.0;

   -- Model Interface Properties --
   s28    : constant := 28;
   s28x28 : constant := 28 * 28;

   -- SDL Interface Properties --
   Scaling_Factor : constant := 10;
   Image_Width    : constant := s28 * Scaling_Factor;
   Image_Height   : constant := s28 * Scaling_Factor;

   pragma Style_Checks (Off);
   Image : ONNX_Runtime.Values.Float_Array (1 .. s28x28) :=
     (o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  1
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  2
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  3
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  4
      o,o,o,o,o,o,X,X,X,X,X,X,X,X,X,X,o,o,o,o,o,o,o,o,o,o,o,o,   --  5
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,   --  6
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,   --  7
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,   --  8
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  9
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  10
      o,o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  11
      o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  12
      o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  13
      o,o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  14
      o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  15
      o,o,o,o,o,o,o,o,o,X,X,X,X,X,X,X,o,o,o,o,o,o,o,o,o,o,o,o,   --  16
      o,o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  17
      o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  18
      o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  19
      o,o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  20
      o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  21
      o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  22
      o,o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  23
      o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  24
      o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  25
      o,o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  26
      o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,   --  27
      o,o,o,o,o,o,o,o,X,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o);  --  28
   pragma Style_Checks (On);

   Env : constant ONNX_Runtime.Environments.Environment :=
     ONNX_Runtime.Environments.Create_Environment;

   Session : ONNX_Runtime.Sessions.Session :=
     Env.Create_Session (Model => "mnist.onnx");
   --  https://github.com/microsoft/onnxruntime-inference-examples/
   --  raw/main/c_cxx/MNIST/mnist.onnx

   procedure Clear_Image is
   begin
      Image := (others => 0.0);
   end Clear_Image;

   procedure Run_ONNX is
      Probability : ONNX_Runtime.Values.Float_Array (0 .. 9);
      Max         : ONNX_Runtime.Values.Element_Index := Probability'First;
      Input       : constant ONNX_Runtime.Values.Value_Array (1 .. 1) :=
                     (1 => ONNX_Runtime.Values.Create_Tensor
                           (Image, (1, 1, s28, s28)));
      Output      : ONNX_Runtime.Values.Value_Array (1 .. 1);
   begin
      Session.Run (Input, Output);

      Output (1).Get_Data (Probability);

      for J in Probability'Range loop
         declare
         begin
            -- Display probability value --
            Ada.Text_IO.Put (Element_Index'Image (J) & ": ");
            Ada.Float_Text_IO.Put
               (Probability (J),
                Fore => 2,
                Aft  => 6,
                Exp  => 0);
            Ada.Text_IO.New_Line;
         end;
         if Probability (Max) < Probability (J) then
            Max := J;
         end if;
      end loop;
      Ada.Text_IO.Put ("Output: " & Element_Index'Image (Max));
      Ada.Text_IO.New_Line;
   end Run_ONNX;

   procedure Create_Display is
   begin
      if not SDL.Initialise (SDL_Flags) then
         raise SDL_Error with "SDL Initialize failed";
      end if;

      SDL.Video.Windows.Makers.Create
         (Win      => Window,
          Title    => "ONNX MNIST Example",
          Position => (SDL.Video.Windows.Centered_Window_Position,
                       SDL.Video.Windows.Centered_Window_Position),
          Size     => (Dimension (Image_Width), Dimension (Image_Height)),
          Flags    => SDL.Video.Windows.OpenGL or
                      SDL.Video.Windows.Shown);

      SDL.Video.Renderers.Makers.Create (Renderer, Window, Renderer_Flag);

      SDL.Video.Textures.Makers.Create
         (Tex      => Texture,
          Renderer => Renderer,
          Format   => SDL.Video.Pixel_Formats.Pixel_Format_ARGB_8888,
          Kind     => SDL.Video.Textures.Streaming,
          Size     => (Image_Width, Image_Height));
   end Create_Display;

   procedure Get_Events is
   begin
      while SDL.Events.Events.Poll (Event) loop
         case Event.Common.Event_Type is
            when SDL.Events.Quit =>
               Shutdown := True;
            when SDL.Events.Mice.Button_Down =>
               Mouse_Button_State := Button_Down;
            when SDL.Events.Mice.Button_Up =>
               Mouse_Button_State := Button_Up;
            when others =>
               null;
         end case;
      end loop;
   end Get_Events;

   procedure Process_Events is
   begin
      if Mouse_Button_State = Button_Down then
         declare
            Mouse_Position_X : SDL.Events.Mice.Movement_Values;
            Mouse_Position_Y : SDL.Events.Mice.Movement_Values;
            Mask : Button_Masks;
         begin
            Mask := SDL.Inputs.Mice.Get_State
                        (Mouse_Position_X, Mouse_Position_Y);
            if Mask = SDL.Events.Mice.Right_Mask then
               --  Reset model input
               Clear_Image;
            else
               --  Draw pixel of model input
               Image (Element_Index
                  ((Mouse_Position_X / Scaling_Factor) +
                   (Mouse_Position_Y / Scaling_Factor) * s28)) := 1.0;
            end if;
            New_Input := True;
         end;
      end if;
   end Process_Events;

   procedure Render_Display is
   begin
      Lock (Texture, Pixels);
      declare
         function To_Address is new Ada.Unchecked_Conversion
            (Source => SDL.Video.Pixels.ARGB_8888_Access.Pointer,
             Target => System.Address);
         Surface : Texture_Array (1 .. Image_Height, 1 .. Image_Width)
                   with Address => To_Address (Pixels);
         Pixel   : SDL.Video.Pixels.ARGB_8888;

         procedure Draw_Block
            (X, Y  : Integer;
             Pixel : SDL.Video.Pixels.ARGB_8888)
         is
            X_Scale : constant Integer := (X - 1) * Scaling_Factor;
            Y_Scale : constant Integer := (Y - 1) * Scaling_Factor;
         begin
            for L in 1 .. Scaling_Factor - 1 loop
               for M in 1 .. Scaling_Factor - 1 loop
                  Surface (SDL.Dimension (Y_Scale + L),
                           SDL.Dimension (X_Scale + M)) := Pixel;
               end loop;
            end loop;
         end Draw_Block;
      begin
         for X in 1 .. s28 loop
            for Y in 1 .. s28 loop
               if Image (Element_Index (X + (Y - 1) * s28)) = 1.0 then
                  Pixel.Alpha := 0;
                  Pixel.Red   := 0;
                  Pixel.Green := 0;
                  Pixel.Blue  := 0;
                  Draw_Block (X, Y, Pixel);
               else
                  Pixel.Alpha := 0;
                  Pixel.Red   := 255;
                  Pixel.Green := 255;
                  Pixel.Blue  := 255;
                  Draw_Block (X, Y, Pixel);
               end if;
            end loop;
         end loop;
      end;
      Texture.Unlock;

      Renderer.Clear;
      Renderer.Copy (Texture);
      Renderer.Present;
   end Render_Display;

begin

   Ada.Text_IO.Put_Line ("Usage: Left-click to draw. Right-click to clear.");

   Create_Display;

   loop
      Get_Events;
      Process_Events;
      if New_Input then
         Run_ONNX;
         Render_Display;
         New_Input := False;
      else
         delay 0.1;
      end if;
      exit when Shutdown;
   end loop;

   SDL.Finalise;
end MNIST_SDL;
