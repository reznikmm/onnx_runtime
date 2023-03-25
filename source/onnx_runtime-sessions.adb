--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

package body ONNX_Runtime.Sessions is

   ---------------------
   -- Internal_Create --
   ---------------------

   function Internal_Create
     (Env     : access ONNX_Runtime.C_API.OrtEnv;
      Model   : String;
      Options : ONNX_Runtime.Session_Options.Session_Options) return Session is
   begin
      return Result : Session do
         Check_Status
           (API.CreateSessionFromArray
              (Env,
               Model'Address, Model'Length,
               ONNX_Runtime.Session_Options.Internal (Options),
               Result.Value'Address));
      end return;
   end Internal_Create;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Session) is
   begin
      if Self.Value /= null then
         API.ReleaseSession (Self.Value);
         Self.Value := null;
      end if;
   end Finalize;

end ONNX_Runtime.Sessions;
