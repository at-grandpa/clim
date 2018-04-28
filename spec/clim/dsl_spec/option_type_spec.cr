require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -d=DEFAULT_TYPE                  Option description. [type:String]
                          --default-type=DEFAULT_TYPE      Option description. [type:String]
                          --default-type-default=DEFAULT_TYPE
                                                           Option description. [type:String] [default:\"Default String!\"]
                          -i=VALUE, --int8=VALUE           Option description. [type:Int8]
                          --int8-default=VALUE             Option description. [type:Int8] [default:1]
                          --int16=VALUE                    Option description. [type:Int16]
                          --int32=VALUE                    Option description. [type:Int32]
                          --int64=VALUE                    Option description. [type:Int64]
                          --uint8=VALUE                    Option description. [type:UInt8]
                          --uint16=VALUE                   Option description. [type:UInt16]
                          --uint32=VALUE                   Option description. [type:UInt32]
                          --uint64=VALUE                   Option description. [type:UInt64]
                          --float32=VALUE                  Option description. [type:Float32]
                          --float64=VALUE                  Option description. [type:Float64]
                          --string=VALUE                   Option description. [type:String]
                          --bool                           Option description. [type:Bool]
                          --bool-equal=BOOL                Option description. [type:Bool]
                          --bool-default                   Option description. [type:Bool] [default:false]
                          --array-int8=VALUE               Option description. [type:Array(Int8)]
                          --array-int16=VALUE              Option description. [type:Array(Int16)]
                          --array-int32=VALUE              Option description. [type:Array(Int32)]
                          --array-int64=VALUE              Option description. [type:Array(Int64)]
                          --array-int8-default=VALUE       Option description. [type:Array(Int8)] [default:[] of Int8]
                          --array-int8-default-value=VALUE Option description. [type:Array(Int8)] [default:[1_i8, 2_i8, 3_i8]]
                          --array-int16-default=VALUE      Option description. [type:Array(Int16)] [default:[] of Int16]
                          --array-int32-default=VALUE      Option description. [type:Array(Int32)] [default:[] of Int32]
                          --array-int64-default=VALUE      Option description. [type:Array(Int64)] [default:[] of Int64]
                          --array-uint8=VALUE              Option description. [type:Array(UInt8)]
                          --array-uint16=VALUE             Option description. [type:Array(UInt16)]
                          --array-uint32=VALUE             Option description. [type:Array(UInt32)]
                          --array-uint64=VALUE             Option description. [type:Array(UInt64)]
                          --array-uint8-default=VALUE      Option description. [type:Array(UInt8)] [default:[] of UInt8]
                          --array-uint16-default=VALUE     Option description. [type:Array(UInt16)] [default:[] of UInt16]
                          --array-uint32-default=VALUE     Option description. [type:Array(UInt32)] [default:[] of UInt32]
                          --array-uint64-default=VALUE     Option description. [type:Array(UInt64)] [default:[] of UInt64]
                          --array-float32=VALUE            Option description. [type:Array(Float32)]
                          --array-float64=VALUE            Option description. [type:Array(Float64)]
                          --array-string=VALUE             Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: OptionTypeSpec,
  spec_dsl_lines: [
    "option \"-d=DEFAULT_TYPE\"",
    "option \"--default-type=DEFAULT_TYPE\"",
    "option \"--default-type-default=DEFAULT_TYPE\", default: \"Default String!\"",
    "option \"-i=VALUE\", \"--int8=VALUE\", type: Int8",
    "option \"--int8-default=VALUE\", type: Int8, default: 1_i8",
    "option \"--int16=VALUE\", type: Int16",
    "option \"--int32=VALUE\", type: Int32",
    "option \"--int64=VALUE\", type: Int64",
    "option \"--uint8=VALUE\", type: UInt8",
    "option \"--uint16=VALUE\", type: UInt16",
    "option \"--uint32=VALUE\", type: UInt32",
    "option \"--uint64=VALUE\", type: UInt64",
    "option \"--float32=VALUE\", type: Float32",
    "option \"--float64=VALUE\", type: Float64",
    "option \"--string=VALUE\", type: String",
    "option \"--bool\", type: Bool",
    "option \"--bool-equal=BOOL\", type: Bool",
    "option \"--bool-default\", type: Bool, default: false",
    "option \"--array-int8=VALUE\", type: Array(Int8)",
    "option \"--array-int16=VALUE\", type: Array(Int16)",
    "option \"--array-int32=VALUE\", type: Array(Int32)",
    "option \"--array-int64=VALUE\", type: Array(Int64)",
    "option \"--array-int8-default=VALUE\", type: Array(Int8), default: [] of Int8",
    "option \"--array-int8-default-value=VALUE\", type: Array(Int8), default: [1_i8,2_i8,3_i8]",
    "option \"--array-int16-default=VALUE\", type: Array(Int16), default: [] of Int16",
    "option \"--array-int32-default=VALUE\", type: Array(Int32), default: [] of Int32",
    "option \"--array-int64-default=VALUE\", type: Array(Int64), default: [] of Int64",
    "option \"--array-uint8=VALUE\", type: Array(UInt8)",
    "option \"--array-uint16=VALUE\", type: Array(UInt16)",
    "option \"--array-uint32=VALUE\", type: Array(UInt32)",
    "option \"--array-uint64=VALUE\", type: Array(UInt64)",
    "option \"--array-uint8-default=VALUE\", type: Array(UInt8), default: [] of UInt8",
    "option \"--array-uint16-default=VALUE\", type: Array(UInt16), default: [] of UInt16",
    "option \"--array-uint32-default=VALUE\", type: Array(UInt32), default: [] of UInt32",
    "option \"--array-uint64-default=VALUE\", type: Array(UInt64), default: [] of UInt64",
    "option \"--array-float32=VALUE\", type: Array(Float32)",
    "option \"--array-float64=VALUE\", type: Array(Float64)",
    "option \"--array-string=VALUE\", type: Array(String)",
  ],
  spec_desc: "option type spec,",
  spec_cases: [

    # ====================================================
    # Default type (String)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "d",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-d", "foo", "bar"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "d",
        "expect_value" => "foo",
      },
      expect_args: ["bar"]
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "default_type",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--default-type", "foo", "bar"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "default_type",
        "expect_value" => "foo",
      },
      expect_args: ["bar"]
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "default_type_default",
        "expect_value" => "Default String!",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--default-type-default", "foo", "bar"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "default_type_default",
        "expect_value" => "foo",
      },
      expect_args: ["bar"]
    },

    # ====================================================
    # Int8
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int8?,
        "method" => "int8",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-i", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int8?,
        "method" => "int8",
        "expect_value" => 5_i8,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-i", "foo"],
      exception_message: "Invalid Int8: foo",
    },
    {
      argv:        ["--int8", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int8?,
        "method" => "int8",
        "expect_value" => 5_i8,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--int8", "foo"],
      exception_message: "Invalid Int8: foo",
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int8,
        "method" => "int8_default",
        "expect_value" => 1_i8,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--int8-default", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int8,
        "method" => "int8_default",
        "expect_value" => 5_i8,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--int8-default", "foo"],
      exception_message: "Invalid Int8: foo",
    },

    # ====================================================
    # Int16
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int16?,
        "method" => "int16",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--int16", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int16?,
        "method" => "int16",
        "expect_value" => 5_i16,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--int16", "foo"],
      exception_message: "Invalid Int16: foo",
    },

    # ====================================================
    # Int32
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int32?,
        "method" => "int32",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--int32", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int32?,
        "method" => "int32",
        "expect_value" => 5_i32,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--int32", "foo"],
      exception_message: "Invalid Int32: foo",
    },

    # ====================================================
    # Int64
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int64?,
        "method" => "int64",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--int64", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Int64?,
        "method" => "int64",
        "expect_value" => 5_i64,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--int64", "foo"],
      exception_message: "Invalid Int64: foo",
    },

    # ====================================================
    # UInt8
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt8?,
        "method" => "uint8",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--uint8", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt8?,
        "method" => "uint8",
        "expect_value" => 5_u8,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--uint8", "foo"],
      exception_message: "Invalid UInt8: foo",
    },

    # ====================================================
    # UInt16
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt16?,
        "method" => "uint16",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--uint16", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt16?,
        "method" => "uint16",
        "expect_value" => 5_u16,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--uint16", "foo"],
      exception_message: "Invalid UInt16: foo",
    },

    # ====================================================
    # UInt32
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt32?,
        "method" => "uint32",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--uint32", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt32?,
        "method" => "uint32",
        "expect_value" => 5_u32,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--uint32", "foo"],
      exception_message: "Invalid UInt32: foo",
    },

    # ====================================================
    # UInt64
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt64?,
        "method" => "uint64",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--uint64", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => UInt64?,
        "method" => "uint64",
        "expect_value" => 5_u64,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--uint64", "foo"],
      exception_message: "Invalid UInt64: foo",
    },

    # ====================================================
    # Float32
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Float32?,
        "method" => "float32",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--float32", "5.5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Float32?,
        "method" => "float32",
        "expect_value" => 5.5_f32,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--float32", "foo"],
      exception_message: "Invalid Float32: foo",
    },

    # ====================================================
    # Float64
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Float64?,
        "method" => "float64",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--float64", "5.5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Float64?,
        "method" => "float64",
        "expect_value" => 5.5_f64,
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--float64", "foo"],
      exception_message: "Invalid Float64: foo",
    },

    # ====================================================
    # String
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--string", "5"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "5",
      },
      expect_args: [] of String,
    },

    # ====================================================
    # Bool
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool-default"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool_default",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },

    # ====================================================
    # Array(Int8)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8",
        "expect_value" => [] of Int8,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int8", "1", "--array-int8", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8",
        "expect_value" => [1_i8, 2_i8],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int8", "foo"],
      exception_message: "Invalid Int8: foo",
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8_default",
        "expect_value" => [] of Int8,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int8-default", "1", "--array-int8-default", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8_default",
        "expect_value" => [1_i8, 2_i8],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int8-default", "foo"],
      exception_message: "Invalid Int8: foo",
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8_default_value",
        "expect_value" => [1_i8, 2_i8, 3_i8],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int8-default-value", "8", "--array-int8-default-value", "9"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8),
        "method" => "array_int8_default_value",
        "expect_value" => [8_i8, 9_i8],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int8-default-value", "foo"],
      exception_message: "Invalid Int8: foo",
    },

    # ====================================================
    # Array(Int16)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int16),
        "method" => "array_int16",
        "expect_value" => [] of Int16,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int16", "1", "--array-int16", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int16),
        "method" => "array_int16",
        "expect_value" => [1_i16, 2_i16],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int16", "foo"],
      exception_message: "Invalid Int16: foo",
    },

    # ====================================================
    # Array(Int32)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int32),
        "method" => "array_int32",
        "expect_value" => [] of Int32,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int32", "1", "--array-int32", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int32),
        "method" => "array_int32",
        "expect_value" => [1_i32, 2_i32],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int32", "foo"],
      exception_message: "Invalid Int32: foo",
    },

    # ====================================================
    # Array(Int64)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int64),
        "method" => "array_int64",
        "expect_value" => [] of Int64,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int64", "1", "--array-int64", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int64),
        "method" => "array_int64",
        "expect_value" => [1_i64, 2_i64],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-int64", "foo"],
      exception_message: "Invalid Int64: foo",
    },

    # ====================================================
    # Array(UInt8)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt8),
        "method" => "array_uint8",
        "expect_value" => [] of UInt8,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-uint8", "1", "--array-uint8", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt8),
        "method" => "array_uint8",
        "expect_value" => [1_u8, 2_u8],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-uint8", "foo"],
      exception_message: "Invalid UInt8: foo",
    },

    # ====================================================
    # Array(UInt16)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt16),
        "method" => "array_uint16",
        "expect_value" => [] of UInt16,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-uint16", "1", "--array-uint16", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt16),
        "method" => "array_uint16",
        "expect_value" => [1_u16, 2_u16],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-uint16", "foo"],
      exception_message: "Invalid UInt16: foo",
    },

    # ====================================================
    # Array(UInt32)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt32),
        "method" => "array_uint32",
        "expect_value" => [] of UInt32,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-uint32", "1", "--array-uint32", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt32),
        "method" => "array_uint32",
        "expect_value" => [1_u32, 2_u32],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-uint32", "foo"],
      exception_message: "Invalid UInt32: foo",
    },

    # ====================================================
    # Array(UInt64)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt64),
        "method" => "array_uint64",
        "expect_value" => [] of UInt64,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-uint64", "1", "--array-uint64", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(UInt64),
        "method" => "array_uint64",
        "expect_value" => [1_u64, 2_u64],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-uint64", "foo"],
      exception_message: "Invalid UInt64: foo",
    },

    # ====================================================
    # Array(Float32)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Float32),
        "method" => "array_float32",
        "expect_value" => [] of Float32,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-float32", "1.1", "--array-float32", "2.2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Float32),
        "method" => "array_float32",
        "expect_value" => [1.1_f32, 2.2_f32],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-float32", "foo"],
      exception_message: "Invalid Float32: foo",
    },

    # ====================================================
    # Array(Float64)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Float64),
        "method" => "array_float64",
        "expect_value" => [] of Float64,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-float64", "1.1", "--array-float64", "2.2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Float64),
        "method" => "array_float64",
        "expect_value" => [1.1_f64, 2.2_f64],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["--array-float64", "foo"],
      exception_message: "Invalid Float64: foo",
    },

    # ====================================================
    # Array(String)
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String),
        "method" => "array_string",
        "expect_value" => [] of String,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-string", "array1", "--array-string", "array2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String),
        "method" => "array_string",
        "expect_value" => ["array1", "array2"],
      },
      expect_args: [] of String,
    },
  ]
)
{% end %}
