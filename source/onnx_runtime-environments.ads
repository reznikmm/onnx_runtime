--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

private with Ada.Finalization;
private with ONNX_Runtime.C_API;

with ONNX_Runtime.Sessions;
with ONNX_Runtime.Session_Options;

package ONNX_Runtime.Environments is
   pragma Preelaborate;

   type Environment is tagged limited private;

   type Logging_Level is (Verbose, Info, Warning, Error, Fatal);
   --  Logging severity levels.

   function Create_Environment
     (Logging : Logging_Level := Warning;
      Log_Id  : String := "") return Environment;
   --  Create an OrtEnv.

   function Create_Session
     (Self    : Environment'Class;
      Model   : String;
      Options : ONNX_Runtime.Session_Options.Session_Options :=
        ONNX_Runtime.Session_Options.Default_Options)
          return ONNX_Runtime.Sessions.Session;
   --  Create an OrtSession from a model file.

private

   type Environment is new Ada.Finalization.Limited_Controlled with record
      Value : access ONNX_Runtime.C_API.OrtEnv;
   end record;

   overriding procedure Finalize (Self : in out Environment);

   function Create_Session
     (Self    : Environment'Class;
      Model   : String;
      Options : ONNX_Runtime.Session_Options.Session_Options :=
        ONNX_Runtime.Session_Options.Default_Options)
          return ONNX_Runtime.Sessions.Session is
            (ONNX_Runtime.Sessions.Internal_Create
               (Self.Value, Model, Options));

end ONNX_Runtime.Environments;
