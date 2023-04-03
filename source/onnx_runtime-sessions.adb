--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

pragma Extensions_Allowed (On);

with Interfaces.C.Strings;

package body ONNX_Runtime.Sessions is

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

   ---------------------
   -- Internal_Create --
   ---------------------

   function Internal_Create
     (Env     : access ONNX_Runtime.C_API.OrtEnv;
      Model   : String;
      Options : ONNX_Runtime.Session_Options.Session_Options) return Session
   is
      C_Model : Interfaces.C.Strings.chars_ptr :=
        Interfaces.C.Strings.New_String (Model);
   begin
      return Result : Session do
         Check_Status
           (API.CreateSession
              (Env,
               C_Model,
               ONNX_Runtime.Session_Options.Internal (Options),
               Result.Value'Address));
         Interfaces.C.Strings.Free (C_Model);
      end return;
   end Internal_Create;

   procedure Run
     (Self   : in out Session'Class;
      Input  : ONNX_Runtime.Values.Value_Array;
      Output : out ONNX_Runtime.Values.Value_Array)
   is
      Run_Option : access ONNX_Runtime.C_API.OrtRunOptions;
      Input_Name : aliased Interfaces.C.Strings.chars_ptr :=
        Interfaces.C.Strings.New_String ("Input3");

      Output_Name : aliased Interfaces.C.Strings.chars_ptr :=
        Interfaces.C.Strings.New_String ("Plus214_Output_0");
      Inputs     : array (Input'Range) of aliased access
        ONNX_Runtime.C_API.OrtValue := [for X of Input => X.Internal];
      Outputs    : array (Output'Range) of aliased
        ONNX_Runtime.Values.OrtValue_Access := [others => null];
   begin
      Check_Status (API.CreateRunOptions (Run_Option'Address));
      Check_Status
        (API.Run
           (Self.Value,
            Run_Option,
            Input_Name'Address,
            Inputs'Address,
            Input'Length,
            Output_Name'Address,
            Output'Length,
            Outputs'Address));

      for J in Output'Range loop
         Output (J).Set_Internal (Outputs (J));
         --  ONNX_Runtime.Values.Set_Internal (Output (J), Outputs (J));
      end loop;

      API.ReleaseRunOptions (Run_Option);
   end Run;

end ONNX_Runtime.Sessions;
