require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          --int8=VALUE                     Option description. [type:Int8]
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
                          --array-string=VALUE             Option description. [type:Array(String)]
                          --array-int8=VALUE               Option description. [type:Array(Int8)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: OptionTypeSpec,
  spec_dsl_lines: [
    "option \"--int8=VALUE\", type: Int8",
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
    "option \"--array-string=VALUE\", type: Array(String)",
    "option \"--array-int8=VALUE\", type: Array(Int8)",
  ],
  spec_desc: "option type spec,",
  spec_cases: [
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
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array_string",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-string", "array1", "--array-string", "array2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array_string",
        "expect_value" => ["array1", "array2"],
      },
      expect_args: [] of String,
    },

    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8)?,
        "method" => "array_int8",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array-int8", "1", "--array-int8", "2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(Int8)?,
        "method" => "array_int8",
        "expect_value" => [1_i8, 2_i8],
      },
      expect_args: [] of String,
    },



  ]
)
{% end %}
