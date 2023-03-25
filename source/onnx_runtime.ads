--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

limited with ONNX_Runtime.C_API;

package ONNX_Runtime is
   pragma Preelaborate;

private
   function API return not null access constant ONNX_Runtime.C_API.OrtApi
     with Inline;

   procedure Check_Status (Value : access ONNX_Runtime.C_API.OrtStatus);
end ONNX_Runtime;
