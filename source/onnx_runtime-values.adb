--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

pragma Extensions_Allowed (on);

with Interfaces;
with Interfaces.C;
with System;

package body ONNX_Runtime.Values is

   use type Interfaces.C.size_t;

   function Internal_Create_Tensor
     (Buffer    : System.Address;
      Size      : Interfaces.C.size_t;
      Tipe      : ONNX_Runtime.C_API.ONNXTensorElementDataType;
      Shape     : Element_Index_Array) return Value;

   -------------------
   -- Create_Tensor --
   -------------------

   function Create_Tensor
     (Flat_Data : Float_Array;
      Shape     : Element_Index_Array) return Value is
       (Internal_Create_Tensor
         (Flat_Data'Address,
          Flat_Data'Size / 8,
          ONNX_Runtime.C_API.ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT,
          Shape));

   function Create_Tensor
     (Flat_Data : Int64_Array;
      Shape     : Element_Index_Array) return Value is
       (Internal_Create_Tensor
         (Flat_Data'Address,
          Flat_Data'Size / 8,
          ONNX_Runtime.C_API.ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64,
          Shape));

   ----------------------------
   -- Internal_Create_Tensor --
   ----------------------------

   function Internal_Create_Tensor
     (Buffer    : System.Address;
      Size      : Interfaces.C.size_t;
      Tipe      : ONNX_Runtime.C_API.ONNXTensorElementDataType;
      Shape     : Element_Index_Array) return Value
   is
      Memory_Info : access ONNX_Runtime.C_API.OrtMemoryInfo;
      C_Shape     : array (Shape'Range) of aliased Interfaces.Integer_64 :=
        [for X of Shape => Interfaces.Integer_64 (X)];
   begin
      Check_Status
        (API.CreateCpuMemoryInfo
           (ONNX_Runtime.C_API.OrtAllocatorType_OrtArenaAllocator,
            ONNX_Runtime.C_API.OrtMemType_OrtMemTypeDefault,
            Memory_Info'Address));

      return Result : Value do
         Check_Status
           (API.CreateTensorWithDataAsOrtValue
              (Memory_Info,
               Buffer, Size,
               C_Shape (Shape'First)'Unchecked_Access, Shape'Length,
               Tipe,
               Result.Value'Address));
         API.ReleaseMemoryInfo (Memory_Info);
      end return;
   end Internal_Create_Tensor;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Value) is
   begin
      if Self.Value /= null then
         API.ReleaseValue (Self.Value);
         Self.Value := null;
      end if;
   end Finalize;

   --------------
   -- Get_Data --
   --------------

   procedure Get_Data
     (Self : Value'Class;
      Data : out Float_Array)
   is
      Storage : System.Address;
   begin
      Check_Status
        (API.GetTensorMutableData (Self.Value, Storage'Address));

      declare
         Buffer : Float_Array (Data'Range)
           with Import, Address => Storage;
      begin
         Data := Buffer;
      end;
   end Get_Data;

   ------------
   -- Length --
   ------------

   function Length (Self : Value'Class) return Element_Index is
      Shape  : access ONNX_Runtime.C_API.OrtTensorTypeAndShapeInfo;
      Result : aliased Interfaces.C.size_t;
   begin
      Check_Status (API.GetTensorTypeAndShape (Self.Value, Shape'Address));
      Check_Status (API.GetTensorShapeElementCount (Shape, Result'Access));
      API.ReleaseTensorTypeAndShapeInfo (Shape);

      return Element_Index (Result);
   end Length;

   ------------------
   -- Set_Internal --
   ------------------

   procedure Set_Internal
     (Self : out Value'Class;
      Item : OrtValue_Access) is
   begin
      Finalize (Self);
      Self.Value := Item;
   end Set_Internal;

end ONNX_Runtime.Values;
