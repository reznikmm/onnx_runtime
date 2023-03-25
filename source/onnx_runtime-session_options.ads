--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

private with Ada.Finalization;
with ONNX_Runtime.C_API;

package ONNX_Runtime.Session_Options is
   pragma Preelaborate;

   type Session_Options is limited private;

   function Default_Options return Session_Options;

   function Internal (Self : Session_Options)
     return access ONNX_Runtime.C_API.OrtSessionOptions;

private

   type Session_Options is new Ada.Finalization.Limited_Controlled with record
      Value : access ONNX_Runtime.C_API.OrtSessionOptions;
   end record;

   overriding procedure Finalize (Self : in out Session_Options);

   function Internal (Self : Session_Options)
     return access ONNX_Runtime.C_API.OrtSessionOptions is (Self.Value);

end ONNX_Runtime.Session_Options;
