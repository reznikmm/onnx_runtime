--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

pragma Extensions_Allowed (On);

with Ada.Unchecked_Conversion;
with Interfaces.C.Strings;
with System;

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

   ---------
   -- Run --
   ---------

   procedure Run
     (Self   : in out Session'Class;
      Input  : ONNX_Runtime.Values.Value_Array;
      Output : out ONNX_Runtime.Values.Value_Array)
   is

      function Cast is new Ada.Unchecked_Conversion
        (Interfaces.C.Strings.chars_ptr, System.Address);

      function Get_Allocator return access ONNX_Runtime.C_API.OrtAllocator;
      function Get_Input_Count return Natural;
      function Get_Output_Count return Natural;

      -------------------
      -- Get_Allocator --
      -------------------

      function Get_Allocator return access ONNX_Runtime.C_API.OrtAllocator is
      begin
         return Result : access ONNX_Runtime.C_API.OrtAllocator do
            Check_Status (API.GetAllocatorWithDefaultOptions (Result'Address));
         end return;
      end Get_Allocator;

      ---------------------
      -- Get_Input_Count --
      ---------------------

      function Get_Input_Count return Natural is
         Result : aliased Interfaces.C.size_t;
      begin
         Check_Status (API.SessionGetInputCount (Self.Value, Result'Access));
         return Natural (Result);
      end Get_Input_Count;

      ----------------------
      -- Get_Output_Count --
      ----------------------

      function Get_Output_Count return Natural is
         Result : aliased Interfaces.C.size_t;
      begin
         Check_Status (API.SessionGetOutputCount (Self.Value, Result'Access));
         return Natural (Result);
      end Get_Output_Count;

      Run_Option : access ONNX_Runtime.C_API.OrtRunOptions;
      Allocator  : constant access ONNX_Runtime.C_API.OrtAllocator :=
        Get_Allocator;

      Input_Names  : array (Input'Range) of aliased
        Interfaces.C.Strings.chars_ptr;

      Output_Names : array (Output'Range) of aliased
        Interfaces.C.Strings.chars_ptr;

      Inputs     : array (Input'Range) of aliased access
        ONNX_Runtime.C_API.OrtValue := [for X of Input => X.Internal];

      Outputs    : array (Output'Range) of aliased
        ONNX_Runtime.Values.OrtValue_Access := [others => null];
   begin
      pragma Assert (Input'Length = Get_Input_Count);
      pragma Assert (Output'Length = Get_Output_Count);

      for Index in Input'Range loop
         Check_Status (API.SessionGetInputName
          (Self.Value,
           Interfaces.C.size_t (Index - Input'First),
           Allocator,
           Input_Names (Index)'Address));
      end loop;

      for Index in Output'Range loop
         Check_Status (API.SessionGetOutputName
          (Self.Value,
           Interfaces.C.size_t (Index - Output'First),
           Allocator,
           Output_Names (Index)'Address));
      end loop;

      Check_Status (API.CreateRunOptions (Run_Option'Address));

      Check_Status
        (API.Run
           (Self.Value,
            Run_Option,
            Input_Names'Address,
            Inputs'Address,
            Input'Length,
            Output_Names'Address,
            Output'Length,
            Outputs'Address));

      for Index in Output'Range loop
         Output (Index).Set_Internal (Outputs (Index));
         Check_Status
           (API.AllocatorFree (Allocator, Cast (Output_Names (Index))));
      end loop;

      API.ReleaseRunOptions (Run_Option);

      for Index in Input_Names'Range loop
         Check_Status
           (API.AllocatorFree (Allocator, Cast (Input_Names (Index))));
      end loop;
   end Run;

end ONNX_Runtime.Sessions;
