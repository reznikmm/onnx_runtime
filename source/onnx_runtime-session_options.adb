--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

package body ONNX_Runtime.Session_Options is

   ---------------------
   -- Default_Options --
   ---------------------

   function Default_Options return Session_Options is
   begin
      return Result : Session_Options do
         Check_Status (API.CreateSessionOptions (Result.Value'Address));
      end return;
   end Default_Options;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Session_Options) is
   begin
      if Self.Value /= null then
         API.ReleaseSessionOptions (Self.Value);
         Self.Value := null;
      end if;
   end Finalize;

end ONNX_Runtime.Session_Options;
