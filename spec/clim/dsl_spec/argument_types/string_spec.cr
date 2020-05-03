require "../../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: ArgumentTypeSpec,
  spec_dsl_lines: [
    "argument \"arg1\", type: String",
    "argument \"arg2\", type: String",
    "argument \"arg3\", type: String",
    "option \"-a ARG\", \"--array=ARG\", type: Array(String)",
  ],
  spec_desc: "argument type spec,",
  spec_cases: [
    # ====================================================
    # String
    # ====================================================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => nil,
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => nil,
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => nil,
        },
      ],
    },
    {
      argv:        ["value1"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => "value1",
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => nil,
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => nil,
        },
      ],
    },
    {
      argv:        ["value1", "value2"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => "value1",
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => "value2",
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => nil,
        },
      ],
    },
    {
      argv:        ["value1", "value2", "value3"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => "value1",
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => "value2",
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => "value3",
        },
      ],
    },
    {
      argv:        ["value1", "value2", "value3", "value4"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => "value1",
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => "value2",
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => "value3",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["value4"],
        },
      ],
    },
    {
      argv:        ["value1", "value2", "--array", "array_value", "value3", "value4", "value5"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String?,
          "method" => "arg1",
          "expect_value" => "value1",
        },
        {
          "type" => String?,
          "method" => "arg2",
          "expect_value" => "value2",
        },
        {
          "type" => String?,
          "method" => "arg3",
          "expect_value" => "value3",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["value4", "value5"],
        },
      ],
    },
  ]
)
{% end %}
