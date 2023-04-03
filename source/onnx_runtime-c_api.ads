--  SPDX-FileCopyrightText: 2023 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
----------------------------------------------------------------

pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C; use Interfaces.C;
with System;
with Interfaces.C.Strings;

package ONNX_Runtime.C_API is
   pragma Preelaborate;

   ORT_API_VERSION : constant := 14;  --  onnxruntime_c_api.h:33
   --  unsupported macro: ORT_ALL_ARGS_NONNULL __attribute__((nonnull))
   --  unsupported macro: ORT_MUST_USE_RESULT __attribute__((warn_unused_result))
   --  unsupported macro: ORTCHAR_T char
   --  arg-macro: procedure ORT_TSTR (X)
   --    X
   --  unsupported macro: NO_EXCEPTION noexcept
   --  unsupported macro: ORT_API(RETURN_TYPE,NAME,...) RETURN_TYPE ORT_API_CALL NAME(__VA_ARGS__) NO_EXCEPTION
   --  unsupported macro: ORT_API_STATUS(NAME,...) _Success_(return == 0) _Check_return_ _Ret_maybenull_ OrtStatusPtr ORT_API_CALL NAME(__VA_ARGS__) NO_EXCEPTION ORT_MUST_USE_RESULT
   --  unsupported macro: ORT_API2_STATUS(NAME,...) _Check_return_ _Ret_maybenull_ OrtStatusPtr(ORT_API_CALL* NAME)(__VA_ARGS__) NO_EXCEPTION ORT_MUST_USE_RESULT
   --  unsupported macro: ORT_API_STATUS_IMPL(NAME,...) _Success_(return == 0) _Check_return_ _Ret_maybenull_ OrtStatusPtr ORT_API_CALL NAME(__VA_ARGS__) NO_EXCEPTION
   --  unsupported macro: ORT_CLASS_RELEASE(X) void(ORT_API_CALL * Release ##X)(_Frees_ptr_opt_ Ort ##X * input)
   --  unsupported macro: ORT_RUNTIME_CLASS(X) struct Ort ##X; typedef struct Ort ##X Ort ##X;

   type ONNXTensorElementDataType is
     (ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT8,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_INT8,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT16,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_INT16,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_INT32,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_BOOL,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT16,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_DOUBLE,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT32,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT64,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX64,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX128,
      ONNX_TENSOR_ELEMENT_DATA_TYPE_BFLOAT16)
   with Convention => C;  -- onnxruntime_c_api.h:155

   type ONNXType is
     (ONNX_TYPE_UNKNOWN,
      ONNX_TYPE_TENSOR,
      ONNX_TYPE_SEQUENCE,
      ONNX_TYPE_MAP,
      ONNX_TYPE_OPAQUE,
      ONNX_TYPE_SPARSETENSOR,
      ONNX_TYPE_OPTIONAL)
   with Convention => C;  -- onnxruntime_c_api.h:176

   subtype OrtSparseFormat is unsigned;
   OrtSparseFormat_ORT_SPARSE_UNDEFINED : constant OrtSparseFormat := 0;
   OrtSparseFormat_ORT_SPARSE_COO : constant OrtSparseFormat := 1;
   OrtSparseFormat_ORT_SPARSE_CSRC : constant OrtSparseFormat := 2;
   OrtSparseFormat_ORT_SPARSE_BLOCK_SPARSE : constant OrtSparseFormat := 4;  -- onnxruntime_c_api.h:188

   type OrtSparseIndicesFormat is
     (ORT_SPARSE_COO_INDICES,
      ORT_SPARSE_CSR_INNER_INDICES,
      ORT_SPARSE_CSR_OUTER_INDICES,
      ORT_SPARSE_BLOCK_SPARSE_INDICES)
   with Convention => C;  -- onnxruntime_c_api.h:196

   type OrtLoggingLevel is
     (ORT_LOGGING_LEVEL_VERBOSE,
      ORT_LOGGING_LEVEL_INFO,
      ORT_LOGGING_LEVEL_WARNING,
      ORT_LOGGING_LEVEL_ERROR,
      ORT_LOGGING_LEVEL_FATAL)
   with Convention => C;  -- onnxruntime_c_api.h:207

   type OrtErrorCode is
     (ORT_OK,
      ORT_FAIL,
      ORT_INVALID_ARGUMENT,
      ORT_NO_SUCHFILE,
      ORT_NO_MODEL,
      ORT_ENGINE_ERROR,
      ORT_RUNTIME_EXCEPTION,
      ORT_INVALID_PROTOBUF,
      ORT_MODEL_LOADED,
      ORT_NOT_IMPLEMENTED,
      ORT_INVALID_GRAPH,
      ORT_EP_FAIL)
   with Convention => C;  -- onnxruntime_c_api.h:215

   type OrtOpAttrType is
     (ORT_OP_ATTR_UNDEFINED,
      ORT_OP_ATTR_INT,
      ORT_OP_ATTR_INTS,
      ORT_OP_ATTR_FLOAT,
      ORT_OP_ATTR_FLOATS,
      ORT_OP_ATTR_STRING,
      ORT_OP_ATTR_STRINGS)
   with Convention => C;  -- onnxruntime_c_api.h:230

   type OrtEnv is null record;   -- incomplete struct

   type OrtStatus is null record;   -- incomplete struct

   type OrtMemoryInfo is null record;   -- incomplete struct

   type OrtIoBinding is null record;   -- incomplete struct

   type OrtSession is null record;   -- incomplete struct

   type OrtValue is null record;   -- incomplete struct

   type OrtRunOptions is null record;   -- incomplete struct

   type OrtTypeInfo is null record;   -- incomplete struct

   type OrtTensorTypeAndShapeInfo is null record;   -- incomplete struct

   type OrtSessionOptions is null record;   -- incomplete struct

   type OrtCustomOpDomain is null record;   -- incomplete struct

   type OrtMapTypeInfo is null record;   -- incomplete struct

   type OrtSequenceTypeInfo is null record;   -- incomplete struct

   type OrtModelMetadata is null record;   -- incomplete struct

   type OrtThreadPoolParams is null record;   -- incomplete struct

   type OrtThreadingOptions is null record;   -- incomplete struct

   type OrtArenaCfg is null record;   -- incomplete struct

   type OrtPrepackedWeightsContainer is null record;   -- incomplete struct

   type OrtTensorRTProviderOptionsV2 is null record;   -- incomplete struct

   type OrtCUDAProviderOptionsV2 is null record;   -- incomplete struct

   type OrtCANNProviderOptions is null record;   -- incomplete struct

   type OrtOp is null record;   -- incomplete struct

   type OrtOpAttr is null record;   -- incomplete struct

   type OrtStatusPtr is access all OrtStatus;  -- onnxruntime_c_api.h:277

   type OrtAllocator;
   type OrtAllocator is record
      version : aliased Interfaces.Unsigned_32;  -- onnxruntime_c_api.h:287
      Alloc : access function (arg1 : access OrtAllocator; arg2 : Interfaces.C.size_t) return System.Address;  -- onnxruntime_c_api.h:288
      Free : access procedure (arg1 : access OrtAllocator; arg2 : System.Address);  -- onnxruntime_c_api.h:289
      Info : access function (arg1 : access constant OrtAllocator) return access constant OrtMemoryInfo;  -- onnxruntime_c_api.h:290
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:286

   type OrtLoggingFunction is access procedure
        (arg1 : System.Address;
         arg2 : OrtLoggingLevel;
         arg3 : Interfaces.C.Strings.chars_ptr;
         arg4 : Interfaces.C.Strings.chars_ptr;
         arg5 : Interfaces.C.Strings.chars_ptr;
         arg6 : Interfaces.C.Strings.chars_ptr)
   with Convention => C;  -- onnxruntime_c_api.h:293

   subtype GraphOptimizationLevel is unsigned;
   GraphOptimizationLevel_ORT_DISABLE_ALL : constant GraphOptimizationLevel := 0;
   GraphOptimizationLevel_ORT_ENABLE_BASIC : constant GraphOptimizationLevel := 1;
   GraphOptimizationLevel_ORT_ENABLE_EXTENDED : constant GraphOptimizationLevel := 2;
   GraphOptimizationLevel_ORT_ENABLE_ALL : constant GraphOptimizationLevel := 99;  -- onnxruntime_c_api.h:302

   type ExecutionMode is
     (ORT_SEQUENTIAL,
      ORT_PARALLEL)
   with Convention => C;  -- onnxruntime_c_api.h:309

   type OrtLanguageProjection is
     (ORT_PROJECTION_C,
      ORT_PROJECTION_CPLUSPLUS,
      ORT_PROJECTION_CSHARP,
      ORT_PROJECTION_PYTHON,
      ORT_PROJECTION_JAVA,
      ORT_PROJECTION_WINML,
      ORT_PROJECTION_NODEJS)
   with Convention => C;  -- onnxruntime_c_api.h:317

   type OrtKernelInfo is null record;   -- incomplete struct

   type OrtKernelContext is null record;   -- incomplete struct

   type OrtCustomOp;
   subtype OrtAllocatorType is int;
   OrtAllocatorType_OrtInvalidAllocator : constant OrtAllocatorType := -1;
   OrtAllocatorType_OrtDeviceAllocator : constant OrtAllocatorType := 0;
   OrtAllocatorType_OrtArenaAllocator : constant OrtAllocatorType := 1;  -- onnxruntime_c_api.h:334

   subtype OrtMemType is int;
   OrtMemType_OrtMemTypeCPUInput : constant OrtMemType := -2;
   OrtMemType_OrtMemTypeCPUOutput : constant OrtMemType := -1;
   OrtMemType_OrtMemTypeCPU : constant OrtMemType := -1;
   OrtMemType_OrtMemTypeDefault : constant OrtMemType := 0;  -- onnxruntime_c_api.h:343

   type OrtMemoryInfoDeviceType is
     (OrtMemoryInfoDeviceType_CPU,
      OrtMemoryInfoDeviceType_GPU,
      OrtMemoryInfoDeviceType_FPGA)
   with Convention => C;  -- onnxruntime_c_api.h:352

   type OrtCudnnConvAlgoSearch is
     (OrtCudnnConvAlgoSearchExhaustive,
      OrtCudnnConvAlgoSearchHeuristic,
      OrtCudnnConvAlgoSearchDefault)
   with Convention => C;  -- onnxruntime_c_api.h:360

   package Class_OrtCUDAProviderOptions is
      type OrtCUDAProviderOptions is limited record
         device_id : aliased int;  -- onnxruntime_c_api.h:387
         cudnn_conv_algo_search : aliased OrtCudnnConvAlgoSearch;  -- onnxruntime_c_api.h:393
         gpu_mem_limit : aliased Interfaces.C.size_t;  -- onnxruntime_c_api.h:399
         arena_extend_strategy : aliased int;  -- onnxruntime_c_api.h:407
         do_copy_in_default_stream : aliased int;  -- onnxruntime_c_api.h:416
         has_user_compute_stream : aliased int;  -- onnxruntime_c_api.h:421
         user_compute_stream : System.Address;  -- onnxruntime_c_api.h:426
         default_memory_arena_cfg : access OrtArenaCfg;  -- onnxruntime_c_api.h:430
         tunable_op_enabled : aliased int;  -- onnxruntime_c_api.h:436
      end record
      with Import => True,
           Convention => CPP;

      function New_OrtCUDAProviderOptions return OrtCUDAProviderOptions;  -- onnxruntime_c_api.h:372
      pragma CPP_Constructor (New_OrtCUDAProviderOptions, "_ZN22OrtCUDAProviderOptionsC1Ev");
   end;
   use Class_OrtCUDAProviderOptions;
   package Class_OrtROCMProviderOptions is
      type OrtROCMProviderOptions is limited record
         device_id : aliased int;  -- onnxruntime_c_api.h:461
         miopen_conv_exhaustive_search : aliased int;  -- onnxruntime_c_api.h:466
         gpu_mem_limit : aliased Interfaces.C.size_t;  -- onnxruntime_c_api.h:472
         arena_extend_strategy : aliased int;  -- onnxruntime_c_api.h:480
         do_copy_in_default_stream : aliased int;  -- onnxruntime_c_api.h:489
         has_user_compute_stream : aliased int;  -- onnxruntime_c_api.h:494
         user_compute_stream : System.Address;  -- onnxruntime_c_api.h:499
         default_memory_arena_cfg : access OrtArenaCfg;  -- onnxruntime_c_api.h:503
         tunable_op_enabled : aliased int;  -- onnxruntime_c_api.h:509
      end record
      with Import => True,
           Convention => CPP;

      function New_OrtROCMProviderOptions return OrtROCMProviderOptions;  -- onnxruntime_c_api.h:446
      pragma CPP_Constructor (New_OrtROCMProviderOptions, "_ZN22OrtROCMProviderOptionsC1Ev");
   end;
   use Class_OrtROCMProviderOptions;
   type OrtTensorRTProviderOptions is record
      device_id : aliased int;  -- onnxruntime_c_api.h:518
      has_user_compute_stream : aliased int;  -- onnxruntime_c_api.h:519
      user_compute_stream : System.Address;  -- onnxruntime_c_api.h:520
      trt_max_partition_iterations : aliased int;  -- onnxruntime_c_api.h:521
      trt_min_subgraph_size : aliased int;  -- onnxruntime_c_api.h:522
      trt_max_workspace_size : aliased Interfaces.C.size_t;  -- onnxruntime_c_api.h:523
      trt_fp16_enable : aliased int;  -- onnxruntime_c_api.h:524
      trt_int8_enable : aliased int;  -- onnxruntime_c_api.h:525
      trt_int8_calibration_table_name : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:526
      trt_int8_use_native_calibration_table : aliased int;  -- onnxruntime_c_api.h:527
      trt_dla_enable : aliased int;  -- onnxruntime_c_api.h:528
      trt_dla_core : aliased int;  -- onnxruntime_c_api.h:529
      trt_dump_subgraphs : aliased int;  -- onnxruntime_c_api.h:530
      trt_engine_cache_enable : aliased int;  -- onnxruntime_c_api.h:531
      trt_engine_cache_path : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:532
      trt_engine_decryption_enable : aliased int;  -- onnxruntime_c_api.h:533
      trt_engine_decryption_lib_path : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:534
      trt_force_sequential_engine_build : aliased int;  -- onnxruntime_c_api.h:535
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:517

   type OrtMIGraphXProviderOptions is record
      device_id : aliased int;  -- onnxruntime_c_api.h:546
      migraphx_fp16_enable : aliased int;  -- onnxruntime_c_api.h:547
      migraphx_int8_enable : aliased int;  -- onnxruntime_c_api.h:548
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:545

   package Class_OrtOpenVINOProviderOptions is
      type OrtOpenVINOProviderOptions is limited record
         device_type : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:565
         enable_vpu_fast_compile : aliased unsigned_char;  -- onnxruntime_c_api.h:566
         device_id : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:567
         num_of_threads : aliased Interfaces.C.size_t;  -- onnxruntime_c_api.h:568
         cache_dir : Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:569
         context : System.Address;  -- onnxruntime_c_api.h:570
         enable_opencl_throttling : aliased unsigned_char;  -- onnxruntime_c_api.h:571
         enable_dynamic_shapes : aliased unsigned_char;  -- onnxruntime_c_api.h:572
      end record
      with Import => True,
           Convention => CPP;

      function New_OrtOpenVINOProviderOptions return OrtOpenVINOProviderOptions;  -- onnxruntime_c_api.h:557
      pragma CPP_Constructor (New_OrtOpenVINOProviderOptions, "_ZN26OrtOpenVINOProviderOptionsC1Ev");
   end;
   use Class_OrtOpenVINOProviderOptions;
   type OrtApi;
   type OrtTrainingApi is null record;   -- incomplete struct

   type OrtApiBase is record
      GetApi : access function (arg1 : Interfaces.Unsigned_32) return access constant OrtApi;  -- onnxruntime_c_api.h:592
      GetVersionString : access function return Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:593
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:585

   function OrtGetApiBase return access constant OrtApiBase  -- onnxruntime_c_api.h:601
   with Import => True,
        Convention => C,
        External_Name => "OrtGetApiBase";

   type OrtThreadWorkerFn is access procedure (arg1 : System.Address)
   with Convention => C;  -- onnxruntime_c_api.h:608

   type OrtCustomHandleType is record
      uu_place_holder : aliased char;  -- onnxruntime_c_api.h:611
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:610

   type OrtCustomThreadHandle is access constant OrtCustomHandleType;  -- onnxruntime_c_api.h:612

   type OrtCustomCreateThreadFn is access function
        (arg1 : System.Address;
         arg2 : OrtThreadWorkerFn;
         arg3 : System.Address) return OrtCustomThreadHandle
   with Convention => C;  -- onnxruntime_c_api.h:619

   type OrtCustomJoinThreadFn is access procedure (arg1 : OrtCustomThreadHandle)
   with Convention => C;  -- onnxruntime_c_api.h:626

   type RegisterCustomOpsFn is access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtApiBase) return access OrtStatus
   with Convention => C;  -- onnxruntime_c_api.h:628

   --  package Class_OrtApi is
      type OrtApi is limited record
         CreateStatus : access function (arg1 : OrtErrorCode; arg2 : Interfaces.C.Strings.chars_ptr) return access OrtStatus;  -- onnxruntime_c_api.h:648
         GetErrorCode : access function (arg1 : access constant OrtStatus) return OrtErrorCode;  -- onnxruntime_c_api.h:655
         GetErrorMessage : access function (arg1 : access constant OrtStatus) return Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:662
         CreateEnv : access function
              (arg1 : OrtLoggingLevel;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:676
         CreateEnvWithCustomLogger : access function
              (arg1 : OrtLoggingFunction;
               arg2 : System.Address;
               arg3 : OrtLoggingLevel;
               arg4 : Interfaces.C.Strings.chars_ptr;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:689
         EnableTelemetryEvents : access function (arg1 : access constant OrtEnv) return OrtStatusPtr;  -- onnxruntime_c_api.h:699
         DisableTelemetryEvents : access function (arg1 : access constant OrtEnv) return OrtStatusPtr;  -- onnxruntime_c_api.h:707
         CreateSession : access function
              (arg1 : access constant OrtEnv;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtSessionOptions;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:727
         CreateSessionFromArray : access function
              (arg1 : access constant OrtEnv;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t;
               arg4 : access constant OrtSessionOptions;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:740
         Run : access function
              (arg1 : access OrtSession;
               arg2 : access constant OrtRunOptions;
               arg3 : System.Address;
               arg4 : System.Address;
               arg5 : Interfaces.C.size_t;
               arg6 : System.Address;
               arg7 : Interfaces.C.size_t;
               arg8 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:761
         CreateSessionOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:786
         SetOptimizedModelFilePath : access function (arg1 : access OrtSessionOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:795
         CloneSessionOptions : access function (arg1 : access constant OrtSessionOptions; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:805
         SetSessionExecutionMode : access function (arg1 : access OrtSessionOptions; arg2 : ExecutionMode) return OrtStatusPtr;  -- onnxruntime_c_api.h:819
         EnableProfiling : access function (arg1 : access OrtSessionOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:828
         DisableProfiling : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:836
         EnableMemPattern : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:851
         DisableMemPattern : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:861
         EnableCpuMemArena : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:871
         DisableCpuMemArena : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:879
         SetSessionLogId : access function (arg1 : access OrtSessionOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:888
         SetSessionLogVerbosityLevel : access function (arg1 : access OrtSessionOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:899
         SetSessionLogSeverityLevel : access function (arg1 : access OrtSessionOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:908
         SetSessionGraphOptimizationLevel : access function (arg1 : access OrtSessionOptions; arg2 : GraphOptimizationLevel) return OrtStatusPtr;  -- onnxruntime_c_api.h:918
         SetIntraOpNumThreads : access function (arg1 : access OrtSessionOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:934
         SetInterOpNumThreads : access function (arg1 : access OrtSessionOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:948
         CreateCustomOpDomain : access function (arg1 : Interfaces.C.Strings.chars_ptr; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:961
         CustomOpDomain_Add : access function (arg1 : access OrtCustomOpDomain; arg2 : access constant OrtCustomOp) return OrtStatusPtr;  -- onnxruntime_c_api.h:972
         AddCustomOpDomain : access function (arg1 : access OrtSessionOptions; arg2 : access OrtCustomOpDomain) return OrtStatusPtr;  -- onnxruntime_c_api.h:987
         RegisterCustomOpsLibrary : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1005
         SessionGetInputCount : access function (arg1 : access constant OrtSession; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1022
         SessionGetOutputCount : access function (arg1 : access constant OrtSession; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1035
         SessionGetOverridableInitializerCount : access function (arg1 : access constant OrtSession; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1046
         SessionGetInputTypeInfo : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1056
         SessionGetOutputTypeInfo : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1066
         SessionGetOverridableInitializerTypeInfo : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1076
         SessionGetInputName : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : access OrtAllocator;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1087
         SessionGetOutputName : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : access OrtAllocator;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1098
         SessionGetOverridableInitializerName : access function
              (arg1 : access constant OrtSession;
               arg2 : Interfaces.C.size_t;
               arg3 : access OrtAllocator;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1109
         CreateRunOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1122
         RunOptionsSetRunLogVerbosityLevel : access function (arg1 : access OrtRunOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1133
         RunOptionsSetRunLogSeverityLevel : access function (arg1 : access OrtRunOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1142
         RunOptionsSetRunTag : access function (arg1 : access OrtRunOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:1153
         RunOptionsGetRunLogVerbosityLevel : access function (arg1 : access constant OrtRunOptions; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1164
         RunOptionsGetRunLogSeverityLevel : access function (arg1 : access constant OrtRunOptions; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1174
         RunOptionsGetRunTag : access function (arg1 : access constant OrtRunOptions; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1187
         RunOptionsSetTerminate : access function (arg1 : access OrtRunOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:1197
         RunOptionsUnsetTerminate : access function (arg1 : access OrtRunOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:1207
         CreateTensorAsOrtValue : access function
              (arg1 : access OrtAllocator;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t;
               arg4 : ONNXTensorElementDataType;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1225
         CreateTensorWithDataAsOrtValue : access function
              (arg1 : access constant OrtMemoryInfo;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t;
               arg4 : access Interfaces.Integer_64;
               arg5 : Interfaces.C.size_t;
               arg6 : ONNXTensorElementDataType;
               arg7 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1243
         IsTensor : access function (arg1 : access constant OrtValue; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1254
         GetTensorMutableData : access function (arg1 : access OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1266
         FillStringTensor : access function
              (arg1 : access OrtValue;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1276
         GetStringTensorDataLength : access function (arg1 : access constant OrtValue; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1287
         GetStringTensorContent : access function
              (arg1 : access constant OrtValue;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t;
               arg4 : access Interfaces.C.size_t;
               arg5 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1308
         CastTypeInfoToTensorInfo : access function (arg1 : access constant OrtTypeInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1322
         GetOnnxTypeFromTypeInfo : access function (arg1 : access constant OrtTypeInfo; arg2 : access ONNXType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1332
         CreateTensorTypeAndShapeInfo : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1344
         SetTensorElementType : access function (arg1 : access OrtTensorTypeAndShapeInfo; arg2 : ONNXTensorElementDataType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1353
         SetDimensions : access function
              (arg1 : access OrtTensorTypeAndShapeInfo;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1363
         GetTensorElementType : access function (arg1 : access constant OrtTensorTypeAndShapeInfo; arg2 : access ONNXTensorElementDataType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1374
         GetDimensionsCount : access function (arg1 : access constant OrtTensorTypeAndShapeInfo; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1386
         GetDimensions : access function
              (arg1 : access constant OrtTensorTypeAndShapeInfo;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1396
         GetSymbolicDimensions : access function
              (arg1 : access constant OrtTensorTypeAndShapeInfo;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1407
         GetTensorShapeElementCount : access function (arg1 : access constant OrtTensorTypeAndShapeInfo; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1426
         GetTensorTypeAndShape : access function (arg1 : access constant OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1439
         GetTypeInfo : access function (arg1 : access constant OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1448
         GetValueType : access function (arg1 : access constant OrtValue; arg2 : access ONNXType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1457
         CreateMemoryInfo : access function
              (arg1 : Interfaces.C.Strings.chars_ptr;
               arg2 : OrtAllocatorType;
               arg3 : int;
               arg4 : OrtMemType;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1473
         CreateCpuMemoryInfo : access function
              (arg1 : OrtAllocatorType;
               arg2 : OrtMemType;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1486
         CompareMemoryInfo : access function
              (arg1 : access constant OrtMemoryInfo;
               arg2 : access constant OrtMemoryInfo;
               arg3 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1499
         MemoryInfoGetName : access function (arg1 : access constant OrtMemoryInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1508
         MemoryInfoGetId : access function (arg1 : access constant OrtMemoryInfo; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:1512
         MemoryInfoGetMemType : access function (arg1 : access constant OrtMemoryInfo; arg2 : access OrtMemType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1516
         MemoryInfoGetType : access function (arg1 : access constant OrtMemoryInfo; arg2 : access OrtAllocatorType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1520
         AllocatorAlloc : access function
              (arg1 : access OrtAllocator;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1527
         AllocatorFree : access function (arg1 : access OrtAllocator; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1529
         AllocatorGetInfo : access function (arg1 : access constant OrtAllocator; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1531
         GetAllocatorWithDefaultOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1541
         AddFreeDimensionOverride : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.Integer_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:1558
         GetValue : access function
              (arg1 : access constant OrtValue;
               arg2 : int;
               arg3 : access OrtAllocator;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1605
         GetValueCount : access function (arg1 : access constant OrtValue; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1618
         CreateValue : access function
              (arg1 : System.Address;
               arg2 : Interfaces.C.size_t;
               arg3 : ONNXType;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1635
         CreateOpaqueValue : access function
              (arg1 : Interfaces.C.Strings.chars_ptr;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : System.Address;
               arg4 : Interfaces.C.size_t;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1660
         GetOpaqueValue : access function
              (arg1 : Interfaces.C.Strings.chars_ptr;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtValue;
               arg4 : System.Address;
               arg5 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1677
         KernelInfoGetAttribute_float : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access float) return OrtStatusPtr;  -- onnxruntime_c_api.h:1693
         KernelInfoGetAttribute_int64 : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access Interfaces.Integer_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:1704
         KernelInfoGetAttribute_string : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1727
         KernelContext_GetInputCount : access function (arg1 : access constant OrtKernelContext; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1739
         KernelContext_GetOutputCount : access function (arg1 : access constant OrtKernelContext; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1745
         KernelContext_GetInput : access function
              (arg1 : access constant OrtKernelContext;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1751
         KernelContext_GetOutput : access function
              (arg1 : access OrtKernelContext;
               arg2 : Interfaces.C.size_t;
               arg3 : access Interfaces.Integer_64;
               arg4 : Interfaces.C.size_t;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1758
         ReleaseEnv : access procedure (arg1 : access OrtEnv);  -- onnxruntime_c_api.h:1764
         ReleaseStatus : access procedure (arg1 : access OrtStatus);  -- onnxruntime_c_api.h:1768
         ReleaseMemoryInfo : access procedure (arg1 : access OrtMemoryInfo);  -- onnxruntime_c_api.h:1772
         ReleaseSession : access procedure (arg1 : access OrtSession);  -- onnxruntime_c_api.h:1776
         ReleaseValue : access procedure (arg1 : access OrtValue);  -- onnxruntime_c_api.h:1780
         ReleaseRunOptions : access procedure (arg1 : access OrtRunOptions);  -- onnxruntime_c_api.h:1784
         ReleaseTypeInfo : access procedure (arg1 : access OrtTypeInfo);  -- onnxruntime_c_api.h:1788
         ReleaseTensorTypeAndShapeInfo : access procedure (arg1 : access OrtTensorTypeAndShapeInfo);  -- onnxruntime_c_api.h:1792
         ReleaseSessionOptions : access procedure (arg1 : access OrtSessionOptions);  -- onnxruntime_c_api.h:1796
         ReleaseCustomOpDomain : access procedure (arg1 : access OrtCustomOpDomain);  -- onnxruntime_c_api.h:1800
         GetDenotationFromTypeInfo : access function
              (arg1 : access constant OrtTypeInfo;
               arg2 : System.Address;
               arg3 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:1818
         CastTypeInfoToMapTypeInfo : access function (arg1 : access constant OrtTypeInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1833
         CastTypeInfoToSequenceTypeInfo : access function (arg1 : access constant OrtTypeInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1848
         GetMapKeyType : access function (arg1 : access constant OrtMapTypeInfo; arg2 : access ONNXTensorElementDataType) return OrtStatusPtr;  -- onnxruntime_c_api.h:1866
         GetMapValueType : access function (arg1 : access constant OrtMapTypeInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1875
         GetSequenceElementType : access function (arg1 : access constant OrtSequenceTypeInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1890
         ReleaseMapTypeInfo : access procedure (arg1 : access OrtMapTypeInfo);  -- onnxruntime_c_api.h:1896
         ReleaseSequenceTypeInfo : access procedure (arg1 : access OrtSequenceTypeInfo);  -- onnxruntime_c_api.h:1900
         SessionEndProfiling : access function
              (arg1 : access OrtSession;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1916
         SessionGetModelMetadata : access function (arg1 : access constant OrtSession; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1925
         ModelMetadataGetProducerName : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1939
         ModelMetadataGetGraphName : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1950
         ModelMetadataGetDomain : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1961
         ModelMetadataGetDescription : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1972
         ModelMetadataLookupCustomMetadataMap : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:1985
         ModelMetadataGetVersion : access function (arg1 : access constant OrtModelMetadata; arg2 : access Interfaces.Integer_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:1995
         ReleaseModelMetadata : access procedure (arg1 : access OrtModelMetadata);  -- onnxruntime_c_api.h:1997
         CreateEnvWithGlobalThreadPools : access function
              (arg1 : OrtLoggingLevel;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtThreadingOptions;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2016
         DisablePerSessionThreads : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2032
         CreateThreadingOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2043
         ReleaseThreadingOptions : access procedure (arg1 : access OrtThreadingOptions);  -- onnxruntime_c_api.h:2045
         ModelMetadataGetCustomMetadataMapKeys : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address;
               arg4 : access Interfaces.Integer_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:2062
         AddFreeDimensionOverrideByName : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.Integer_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:2076
         GetAvailableProviders : access function (arg1 : System.Address; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2095
         ReleaseAvailableProviders : access function (arg1 : System.Address; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2104
         GetStringTensorElementLength : access function
              (arg1 : access constant OrtValue;
               arg2 : Interfaces.C.size_t;
               arg3 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2119
         GetStringTensorElement : access function
              (arg1 : access constant OrtValue;
               arg2 : Interfaces.C.size_t;
               arg3 : Interfaces.C.size_t;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2130
         FillStringTensorElement : access function
              (arg1 : access OrtValue;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2140
         AddSessionConfigEntry : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:2158
         CreateAllocator : access function
              (arg1 : access constant OrtSession;
               arg2 : access constant OrtMemoryInfo;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2173
         ReleaseAllocator : access procedure (arg1 : access OrtAllocator);  -- onnxruntime_c_api.h:2178
         RunWithBinding : access function
              (arg1 : access OrtSession;
               arg2 : access constant OrtRunOptions;
               arg3 : access constant OrtIoBinding) return OrtStatusPtr;  -- onnxruntime_c_api.h:2194
         CreateIoBinding : access function (arg1 : access OrtSession; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2207
         ReleaseIoBinding : access procedure (arg1 : access OrtIoBinding);  -- onnxruntime_c_api.h:2215
         BindInput : access function
              (arg1 : access OrtIoBinding;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtValue) return OrtStatusPtr;  -- onnxruntime_c_api.h:2227
         BindOutput : access function
              (arg1 : access OrtIoBinding;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtValue) return OrtStatusPtr;  -- onnxruntime_c_api.h:2239
         BindOutputToDevice : access function
              (arg1 : access OrtIoBinding;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtMemoryInfo) return OrtStatusPtr;  -- onnxruntime_c_api.h:2256
         GetBoundOutputNames : access function
              (arg1 : access constant OrtIoBinding;
               arg2 : access OrtAllocator;
               arg3 : System.Address;
               arg4 : System.Address;
               arg5 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2275
         GetBoundOutputValues : access function
              (arg1 : access constant OrtIoBinding;
               arg2 : access OrtAllocator;
               arg3 : System.Address;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2295
         ClearBoundInputs : access procedure (arg1 : access OrtIoBinding);  -- onnxruntime_c_api.h:2300
         ClearBoundOutputs : access procedure (arg1 : access OrtIoBinding);  -- onnxruntime_c_api.h:2304
         TensorAt : access function
              (arg1 : access OrtValue;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2324
         CreateAndRegisterAllocator : access function
              (arg1 : access OrtEnv;
               arg2 : access constant OrtMemoryInfo;
               arg3 : access constant OrtArenaCfg) return OrtStatusPtr;  -- onnxruntime_c_api.h:2344
         SetLanguageProjection : access function (arg1 : access constant OrtEnv; arg2 : OrtLanguageProjection) return OrtStatusPtr;  -- onnxruntime_c_api.h:2358
         SessionGetProfilingStartTimeNs : access function (arg1 : access constant OrtSession; arg2 : access Interfaces.Unsigned_64) return OrtStatusPtr;  -- onnxruntime_c_api.h:2373
         SetGlobalIntraOpNumThreads : access function (arg1 : access OrtThreadingOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2390
         SetGlobalInterOpNumThreads : access function (arg1 : access OrtThreadingOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2403
         SetGlobalSpinControl : access function (arg1 : access OrtThreadingOptions; arg2 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2418
         AddInitializer : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtValue) return OrtStatusPtr;  -- onnxruntime_c_api.h:2438
         CreateEnvWithCustomLoggerAndGlobalThreadPools : access function
              (arg1 : OrtLoggingFunction;
               arg2 : System.Address;
               arg3 : OrtLoggingLevel;
               arg4 : Interfaces.C.Strings.chars_ptr;
               arg5 : access constant OrtThreadingOptions;
               arg6 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2460
         SessionOptionsAppendExecutionProvider_CUDA : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtCUDAProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2476
         SessionOptionsAppendExecutionProvider_ROCM : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtROCMProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2488
         SessionOptionsAppendExecutionProvider_OpenVINO : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtOpenVINOProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2500
         SetGlobalDenormalAsZero : access function (arg1 : access OrtThreadingOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2517
         CreateArenaCfg : access function
              (arg1 : Interfaces.C.size_t;
               arg2 : int;
               arg3 : int;
               arg4 : int;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2535
         ReleaseArenaCfg : access procedure (arg1 : access OrtArenaCfg);  -- onnxruntime_c_api.h:2538
         ModelMetadataGetGraphDescription : access function
              (arg1 : access constant OrtModelMetadata;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2555
         SessionOptionsAppendExecutionProvider_TensorRT : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtTensorRTProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2571
         SetCurrentGpuDeviceId : access function (arg1 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2588
         GetCurrentGpuDeviceId : access function (arg1 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2600
         KernelInfoGetAttributeArray_float : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access float;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2629
         KernelInfoGetAttributeArray_int64 : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access Interfaces.Integer_64;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2653
         CreateArenaCfgV2 : access function
              (arg1 : System.Address;
               arg2 : access Interfaces.C.size_t;
               arg3 : Interfaces.C.size_t;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2687
         AddRunConfigEntry : access function
              (arg1 : access OrtRunOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:2707
         CreatePrepackedWeightsContainer : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2726
         ReleasePrepackedWeightsContainer : access procedure (arg1 : access OrtPrepackedWeightsContainer);  -- onnxruntime_c_api.h:2732
         CreateSessionWithPrepackedWeightsContainer : access function
              (arg1 : access constant OrtEnv;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access constant OrtSessionOptions;
               arg4 : access OrtPrepackedWeightsContainer;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2755
         CreateSessionFromArrayWithPrepackedWeightsContainer : access function
              (arg1 : access constant OrtEnv;
               arg2 : System.Address;
               arg3 : Interfaces.C.size_t;
               arg4 : access constant OrtSessionOptions;
               arg5 : access OrtPrepackedWeightsContainer;
               arg6 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2777
         SessionOptionsAppendExecutionProvider_TensorRT_V2 : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtTensorRTProviderOptionsV2) return OrtStatusPtr;  -- onnxruntime_c_api.h:2803
         CreateTensorRTProviderOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2816
         UpdateTensorRTProviderOptions : access function
              (arg1 : access OrtTensorRTProviderOptionsV2;
               arg2 : System.Address;
               arg3 : System.Address;
               arg4 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2833
         GetTensorRTProviderOptionsAsString : access function
              (arg1 : access constant OrtTensorRTProviderOptionsV2;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2849
         ReleaseTensorRTProviderOptions : access procedure (arg1 : access OrtTensorRTProviderOptionsV2);  -- onnxruntime_c_api.h:2855
         EnableOrtCustomOps : access function (arg1 : access OrtSessionOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:2867
         RegisterAllocator : access function (arg1 : access OrtEnv; arg2 : access OrtAllocator) return OrtStatusPtr;  -- onnxruntime_c_api.h:2888
         UnregisterAllocator : access function (arg1 : access OrtEnv; arg2 : access constant OrtMemoryInfo) return OrtStatusPtr;  -- onnxruntime_c_api.h:2900
         IsSparseTensor : access function (arg1 : access constant OrtValue; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:2915
         CreateSparseTensorAsOrtValue : access function
              (arg1 : access OrtAllocator;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t;
               arg4 : ONNXTensorElementDataType;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:2933
         FillSparseTensorCoo : access function
              (arg1 : access OrtValue;
               arg2 : access constant OrtMemoryInfo;
               arg3 : access Interfaces.Integer_64;
               arg4 : Interfaces.C.size_t;
               arg5 : System.Address;
               arg6 : access Interfaces.Integer_64;
               arg7 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2953
         FillSparseTensorCsr : access function
              (arg1 : access OrtValue;
               arg2 : access constant OrtMemoryInfo;
               arg3 : access Interfaces.Integer_64;
               arg4 : Interfaces.C.size_t;
               arg5 : System.Address;
               arg6 : access Interfaces.Integer_64;
               arg7 : Interfaces.C.size_t;
               arg8 : access Interfaces.Integer_64;
               arg9 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:2976
         FillSparseTensorBlockSparse : access function
              (arg1 : access OrtValue;
               arg2 : access constant OrtMemoryInfo;
               arg3 : access Interfaces.Integer_64;
               arg4 : Interfaces.C.size_t;
               arg5 : System.Address;
               arg6 : access Interfaces.Integer_64;
               arg7 : Interfaces.C.size_t;
               arg8 : access Interfaces.Integer_32) return OrtStatusPtr;  -- onnxruntime_c_api.h:2999
         CreateSparseTensorWithValuesAsOrtValue : access function
              (arg1 : access constant OrtMemoryInfo;
               arg2 : System.Address;
               arg3 : access Interfaces.Integer_64;
               arg4 : Interfaces.C.size_t;
               arg5 : access Interfaces.Integer_64;
               arg6 : Interfaces.C.size_t;
               arg7 : ONNXTensorElementDataType;
               arg8 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3028
         UseCooIndices : access function
              (arg1 : access OrtValue;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3047
         UseCsrIndices : access function
              (arg1 : access OrtValue;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t;
               arg4 : access Interfaces.Integer_64;
               arg5 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3065
         UseBlockSparseIndices : access function
              (arg1 : access OrtValue;
               arg2 : access Interfaces.Integer_64;
               arg3 : Interfaces.C.size_t;
               arg4 : access Interfaces.Integer_32) return OrtStatusPtr;  -- onnxruntime_c_api.h:3081
         GetSparseTensorFormat : access function (arg1 : access constant OrtValue; arg2 : access OrtSparseFormat) return OrtStatusPtr;  -- onnxruntime_c_api.h:3090
         GetSparseTensorValuesTypeAndShape : access function (arg1 : access constant OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3099
         GetSparseTensorValues : access function (arg1 : access constant OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3108
         GetSparseTensorIndicesTypeShape : access function
              (arg1 : access constant OrtValue;
               arg2 : OrtSparseIndicesFormat;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3119
         GetSparseTensorIndices : access function
              (arg1 : access constant OrtValue;
               arg2 : OrtSparseIndicesFormat;
               arg3 : access Interfaces.C.size_t;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3130
         HasValue : access function (arg1 : access constant OrtValue; arg2 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:3147
         KernelContext_GetGPUComputeStream : access function (arg1 : access constant OrtKernelContext; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3165
         GetTensorMemoryInfo : access function (arg1 : access constant OrtValue; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3176
         GetExecutionProviderApi : access function
              (arg1 : Interfaces.C.Strings.chars_ptr;
               arg2 : Interfaces.Unsigned_32;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3191
         SessionOptionsSetCustomCreateThreadFn : access function (arg1 : access OrtSessionOptions; arg2 : OrtCustomCreateThreadFn) return OrtStatusPtr;  -- onnxruntime_c_api.h:3204
         SessionOptionsSetCustomThreadCreationOptions : access function (arg1 : access OrtSessionOptions; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3213
         SessionOptionsSetCustomJoinThreadFn : access function (arg1 : access OrtSessionOptions; arg2 : OrtCustomJoinThreadFn) return OrtStatusPtr;  -- onnxruntime_c_api.h:3222
         SetGlobalCustomCreateThreadFn : access function (arg1 : access OrtThreadingOptions; arg2 : OrtCustomCreateThreadFn) return OrtStatusPtr;  -- onnxruntime_c_api.h:3234
         SetGlobalCustomThreadCreationOptions : access function (arg1 : access OrtThreadingOptions; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3243
         SetGlobalCustomJoinThreadFn : access function (arg1 : access OrtThreadingOptions; arg2 : OrtCustomJoinThreadFn) return OrtStatusPtr;  -- onnxruntime_c_api.h:3252
         SynchronizeBoundInputs : access function (arg1 : access OrtIoBinding) return OrtStatusPtr;  -- onnxruntime_c_api.h:3263
         SynchronizeBoundOutputs : access function (arg1 : access OrtIoBinding) return OrtStatusPtr;  -- onnxruntime_c_api.h:3273
         SessionOptionsAppendExecutionProvider_CUDA_V2 : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtCUDAProviderOptionsV2) return OrtStatusPtr;  -- onnxruntime_c_api.h:3297
         CreateCUDAProviderOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3312
         UpdateCUDAProviderOptions : access function
              (arg1 : access OrtCUDAProviderOptionsV2;
               arg2 : System.Address;
               arg3 : System.Address;
               arg4 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3331
         GetCUDAProviderOptionsAsString : access function
              (arg1 : access constant OrtCUDAProviderOptionsV2;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3350
         ReleaseCUDAProviderOptions : access procedure (arg1 : access OrtCUDAProviderOptionsV2);  -- onnxruntime_c_api.h:3358
         SessionOptionsAppendExecutionProvider_MIGraphX : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtMIGraphXProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:3373
         AddExternalInitializers : access function
              (arg1 : access OrtSessionOptions;
               arg2 : System.Address;
               arg3 : System.Address;
               arg4 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3397
         CreateOpAttr : access function
              (arg1 : Interfaces.C.Strings.chars_ptr;
               arg2 : System.Address;
               arg3 : int;
               arg4 : OrtOpAttrType;
               arg5 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3411
         ReleaseOpAttr : access procedure (arg1 : access OrtOpAttr);  -- onnxruntime_c_api.h:3424
         CreateOp : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : int;
               arg5 : System.Address;
               arg6 : access ONNXTensorElementDataType;
               arg7 : int;
               arg8 : System.Address;
               arg9 : int;
               arg10 : int;
               arg11 : int;
               arg12 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3443
         InvokeOp : access function
              (arg1 : access constant OrtKernelContext;
               arg2 : access constant OrtOp;
               arg3 : System.Address;
               arg4 : int;
               arg5 : System.Address;
               arg6 : int) return OrtStatusPtr;  -- onnxruntime_c_api.h:3469
         ReleaseOp : access procedure (arg1 : access OrtOp);  -- onnxruntime_c_api.h:3483
         SessionOptionsAppendExecutionProvider : access function
              (arg1 : access OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : System.Address;
               arg4 : System.Address;
               arg5 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3519
         CopyKernelInfo : access function (arg1 : access constant OrtKernelInfo; arg2 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3532
         ReleaseKernelInfo : access procedure (arg1 : access OrtKernelInfo);  -- onnxruntime_c_api.h:3542
         GetTrainingApi : access function (arg1 : Interfaces.Unsigned_32) return access constant OrtTrainingApi;  -- onnxruntime_c_api.h:3548
         SessionOptionsAppendExecutionProvider_CANN : access function (arg1 : access OrtSessionOptions; arg2 : access constant OrtCANNProviderOptions) return OrtStatusPtr;  -- onnxruntime_c_api.h:3561
         CreateCANNProviderOptions : access function (arg1 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3572
         UpdateCANNProviderOptions : access function
              (arg1 : access OrtCANNProviderOptions;
               arg2 : System.Address;
               arg3 : System.Address;
               arg4 : Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3585
         GetCANNProviderOptionsAsString : access function
              (arg1 : access constant OrtCANNProviderOptions;
               arg2 : access OrtAllocator;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3603
         ReleaseCANNProviderOptions : access procedure (arg1 : access OrtCANNProviderOptions);  -- onnxruntime_c_api.h:3612
         MemoryInfoGetDeviceType : access procedure (arg1 : access constant OrtMemoryInfo; arg2 : access OrtMemoryInfoDeviceType);  -- onnxruntime_c_api.h:3618
         UpdateEnvWithCustomLogLevel : access function (arg1 : access OrtEnv; arg2 : OrtLoggingLevel) return OrtStatusPtr;  -- onnxruntime_c_api.h:3627
         SetGlobalIntraOpThreadAffinity : access function (arg1 : access OrtThreadingOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:3648
         RegisterCustomOpsLibrary_V2 : access function (arg1 : access OrtSessionOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:3668
         RegisterCustomOpsUsingFunction : access function (arg1 : access OrtSessionOptions; arg2 : Interfaces.C.Strings.chars_ptr) return OrtStatusPtr;  -- onnxruntime_c_api.h:3694
         KernelInfo_GetInputCount : access function (arg1 : access constant OrtKernelInfo; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3713
         KernelInfo_GetOutputCount : access function (arg1 : access constant OrtKernelInfo; arg2 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3726
         KernelInfo_GetInputName : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.size_t;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3752
         KernelInfo_GetOutputName : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.size_t;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3780
         KernelInfo_GetInputTypeInfo : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3794
         KernelInfo_GetOutputTypeInfo : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.size_t;
               arg3 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3808
         KernelInfoGetAttribute_tensor : access function
              (arg1 : access constant OrtKernelInfo;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access OrtAllocator;
               arg4 : System.Address) return OrtStatusPtr;  -- onnxruntime_c_api.h:3823
         HasSessionConfigEntry : access function
              (arg1 : access constant OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : access int) return OrtStatusPtr;  -- onnxruntime_c_api.h:3846
         GetSessionConfigEntry : access function
              (arg1 : access constant OrtSessionOptions;
               arg2 : Interfaces.C.Strings.chars_ptr;
               arg3 : Interfaces.C.Strings.chars_ptr;
               arg4 : access Interfaces.C.size_t) return OrtStatusPtr;  -- onnxruntime_c_api.h:3877
      end record
      with --  Import => True,
           Convention => CPP;


   --  end;
   --  use Class_OrtApi;
   type OrtCustomOpInputOutputCharacteristic is
     (INPUT_OUTPUT_REQUIRED,
      INPUT_OUTPUT_OPTIONAL,
      INPUT_OUTPUT_VARIADIC)
   with Convention => C;  -- onnxruntime_c_api.h:3902

   type OrtCustomOp is record
      version : aliased Interfaces.Unsigned_32;  -- onnxruntime_c_api.h:3913
      CreateKernel : access function
           (arg1 : access constant OrtCustomOp;
            arg2 : access constant OrtApi;
            arg3 : access constant OrtKernelInfo) return System.Address;  -- onnxruntime_c_api.h:3916
      GetName : access function (arg1 : access constant OrtCustomOp) return Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:3920
      GetExecutionProviderType : access function (arg1 : access constant OrtCustomOp) return Interfaces.C.Strings.chars_ptr;  -- onnxruntime_c_api.h:3923
      GetInputType : access function (arg1 : access constant OrtCustomOp; arg2 : Interfaces.C.size_t) return ONNXTensorElementDataType;  -- onnxruntime_c_api.h:3926
      GetInputTypeCount : access function (arg1 : access constant OrtCustomOp) return Interfaces.C.size_t;  -- onnxruntime_c_api.h:3927
      GetOutputType : access function (arg1 : access constant OrtCustomOp; arg2 : Interfaces.C.size_t) return ONNXTensorElementDataType;  -- onnxruntime_c_api.h:3928
      GetOutputTypeCount : access function (arg1 : access constant OrtCustomOp) return Interfaces.C.size_t;  -- onnxruntime_c_api.h:3929
      KernelCompute : access procedure (arg1 : System.Address; arg2 : access OrtKernelContext);  -- onnxruntime_c_api.h:3932
      KernelDestroy : access procedure (arg1 : System.Address);  -- onnxruntime_c_api.h:3933
      GetInputCharacteristic : access function (arg1 : access constant OrtCustomOp; arg2 : Interfaces.C.size_t) return OrtCustomOpInputOutputCharacteristic;  -- onnxruntime_c_api.h:3936
      GetOutputCharacteristic : access function (arg1 : access constant OrtCustomOp; arg2 : Interfaces.C.size_t) return OrtCustomOpInputOutputCharacteristic;  -- onnxruntime_c_api.h:3937
      GetInputMemoryType : access function (arg1 : access constant OrtCustomOp; arg2 : Interfaces.C.size_t) return OrtMemType;  -- onnxruntime_c_api.h:3944
      GetVariadicInputMinArity : access function (arg1 : access constant OrtCustomOp) return int;  -- onnxruntime_c_api.h:3948
      GetVariadicInputHomogeneity : access function (arg1 : access constant OrtCustomOp) return int;  -- onnxruntime_c_api.h:3953
      GetVariadicOutputMinArity : access function (arg1 : access constant OrtCustomOp) return int;  -- onnxruntime_c_api.h:3957
      GetVariadicOutputHomogeneity : access function (arg1 : access constant OrtCustomOp) return int;  -- onnxruntime_c_api.h:3962
   end record
   with Convention => C_Pass_By_Copy;  -- onnxruntime_c_api.h:3912

   function OrtSessionOptionsAppendExecutionProvider_CUDA (options : access OrtSessionOptions; device_id : int) return OrtStatusPtr  -- onnxruntime_c_api.h:3971
   with Import => True,
        Convention => C,
        External_Name => "OrtSessionOptionsAppendExecutionProvider_CUDA";

   function OrtSessionOptionsAppendExecutionProvider_MIGraphX (options : access OrtSessionOptions; device_id : int) return OrtStatusPtr  -- onnxruntime_c_api.h:3981
   with Import => True,
        Convention => C,
        External_Name => "OrtSessionOptionsAppendExecutionProvider_MIGraphX";

end ONNX_Runtime.C_API;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
