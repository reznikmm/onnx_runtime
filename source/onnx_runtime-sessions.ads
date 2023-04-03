--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

private with Ada.Finalization;

with ONNX_Runtime.Session_Options;
with ONNX_Runtime.C_API;
with ONNX_Runtime.Values;

package ONNX_Runtime.Sessions is

   pragma Preelaborate;

   type Session is tagged limited private;

   function Internal_Create
     (Env     : access ONNX_Runtime.C_API.OrtEnv;
      Model   : String;
      Options : ONNX_Runtime.Session_Options.Session_Options) return Session;
   --  Create an OrtSession from a model file.

   procedure Run
     (Self   : in out Session'Class;
      Input  : ONNX_Runtime.Values.Value_Array;
      Output : out ONNX_Runtime.Values.Value_Array);

private

   type Session is new Ada.Finalization.Limited_Controlled with record
      Value : access ONNX_Runtime.C_API.OrtSession;
   end record;

   overriding procedure Finalize (Self : in out Session);

end ONNX_Runtime.Sessions;
