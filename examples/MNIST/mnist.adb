--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Ada.Text_IO;

with ONNX_Runtime.Environments;
with ONNX_Runtime.Sessions;
with ONNX_Runtime.Values;

procedure MNIST is
   o : constant Float := 0.0;
   X : constant Float := 1.0;

   s28x28 : constant := 28 * 28;

   pragma Style_Checks (Off);
   Image : constant ONNX_Runtime.Values.Float_Array (1 .. s28x28) :=
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

   Output : ONNX_Runtime.Values.Value_Array (1 .. 1);
   Input  : constant ONNX_Runtime.Values.Value_Array (1 .. 1) :=
     (1 => ONNX_Runtime.Values.Create_Tensor (Image, (1, 1, 28, 28)));

   Probability : ONNX_Runtime.Values.Float_Array (0 .. 9);
   Max         : ONNX_Runtime.Values.Element_Index := Probability'First;
begin
   Session.Run (Input, Output);
   Output (1).Get_Data (Probability);

   for J in Probability'Range loop
      if Probability (Max) < Probability (J) then
         Max := J;
      end if;
   end loop;

   Ada.Text_IO.Put_Line ("Result:" & Max'Image);
end MNIST;
