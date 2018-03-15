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
                          --string=VALUE                   Option description. [type:String]
                          --bool                           Option description. [type:Bool]
                          --array-string=VALUE             Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: OptionTypeSpec,
  spec_dsl_lines: [
    "option \"--int8=VALUE\", type: Int8",
    "option \"--int16=VALUE\", type: Int16",
    "option \"--int32=VALUE\", type: Int32",
    "option \"--string=VALUE\", type: String",
    "option \"--bool\", type: Bool",
    "option \"--array-string=VALUE\", type: Array(String)",
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
  ]
)
{% end %}