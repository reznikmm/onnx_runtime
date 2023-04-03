--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Ada.Finalization;

with ONNX_Runtime.C_API;

package ONNX_Runtime.Values is

   pragma Preelaborate;

   type Value is tagged limited private;
   type Value_Array is array (Positive range <>) of Value;

   type Element_Index is range 0 .. 2 ** 63 - 1;
   type Float_Array is array (Element_Index range <>) of Float;
   type Element_Index_Array is array (Positive range <>) of Element_Index;

   function Create_Tensor
     (Flat_Data : Float_Array;
      Shape     : Element_Index_Array) return Value;
   --  with Pre => Flat_Data'Length = Shape'Reduce ("*", 1);
   --  Create a tensor backed by a user supplied buffer.
   --
   --  Create a tensor with user's buffer. You can fill the buffer either
   --  before calling this function or after.

   procedure Get_Data
     (Self : Value'Class;
      Data : out Float_Array);

   function Internal (Self : Value'Class)
     return access ONNX_Runtime.C_API.OrtValue;

   type OrtValue_Access is access all ONNX_Runtime.C_API.OrtValue;

   procedure Set_Internal
     (Self : out Value'Class;
      Item : OrtValue_Access);

private

   type Value is new Ada.Finalization.Limited_Controlled with record
      Value : access ONNX_Runtime.C_API.OrtValue;
   end record;

   overriding procedure Finalize (Self : in out Value);

   function Internal (Self : Value'Class)
     return access ONNX_Runtime.C_API.OrtValue is (Self.Value);

end ONNX_Runtime.Values;
