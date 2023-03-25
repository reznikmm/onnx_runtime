--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Interfaces.C.Strings;

with ONNX_Runtime.C_API;

package body ONNX_Runtime is

   Value : access constant ONNX_Runtime.C_API.OrtApi;

   ---------
   -- API --
   ---------

   function API return not null access constant ONNX_Runtime.C_API.OrtApi is
   begin
      if Value = null then
         Value := ONNX_Runtime.C_API.OrtGetApiBase.GetApi
           (ONNX_Runtime.C_API.ORT_API_VERSION);
      end if;

      return Value;
   end API;

   ------------------
   -- Check_Status --
   ------------------

   procedure Check_Status (Value : access ONNX_Runtime.C_API.OrtStatus) is
   begin
      if Value /= null then
         declare
            Error : constant Interfaces.C.Strings.chars_ptr :=
              API.GetErrorMessage (Value);
         begin
            API.ReleaseStatus (Value);
            raise Program_Error with Interfaces.C.Strings.Value (Error);
         end;
      end if;
   end Check_Status;

end ONNX_Runtime;
