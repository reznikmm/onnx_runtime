--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

with Interfaces.C.Strings;

package body ONNX_Runtime.Environments is

   ------------------------
   -- Create_Environment --
   ------------------------

   function Create_Environment
     (Logging : Logging_Level := Warning; Log_Id : String := "")
      return Environment
   is
      Name  : Interfaces.C.Strings.chars_ptr :=
        Interfaces.C.Strings.New_String (Log_Id);

      Level : constant ONNX_Runtime.C_API.OrtLoggingLevel :=
        ONNX_Runtime.C_API.OrtLoggingLevel'Val (Logging_Level'Pos (Logging));
   begin
      return Result : Environment do
         Check_Status (API.CreateEnv (Level, Name, Result.Value'Address));
         Interfaces.C.Strings.Free (Name);
      end return;
   end Create_Environment;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Environment) is
   begin
      if Self.Value /= null then
         API.ReleaseEnv (Self.Value);
         Self.Value := null;
      end if;
   end Finalize;

end ONNX_Runtime.Environments;
