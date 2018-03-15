require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArray,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String)",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1", "-a", "array2"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1", "array2"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG                           Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayOnlyShortOption,
  spec_dsl_lines: [
    "option \"-a ARG\", type: Array(String)",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "a",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Undefined option. \"--array\"",
    },
    {
      argv:              ["--array", "attay1"],
      exception_message: "Undefined option. \"--array\"",
    },
    {
      argv:              ["--array=array1"],
      exception_message: "Undefined option. \"--array=array1\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Undefined option. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          --array=ARG                      Option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayOnlyLongOption,
  spec_dsl_lines: [
    "option \"--array=ARG\", type: Array(String)",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Undefined option. \"-a\"",
    },
    {
      argv:              ["-a", "attay1"],
      exception_message: "Undefined option. \"-a\"",
    },
    {
      argv:              ["-a=array1"],
      exception_message: "Undefined option. \"-a=array1\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Undefined option. \"-a\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayDesc,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\"",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)] [default:["default value"]]
                          --help                           Show this help.


                      HELP_MESSAGE
%}
spec(
  spec_class_name: MainCommandWithArrayDefault,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\", default: [\"default value\"]",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)] [default:["default value"]] [required]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayRequiredTrueAndDefaultExists,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\", required: true, default: [\"default value\"]",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)] [required]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayRequiredTrueOnly,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\", required: true",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              [] of String,
      exception_message: "Required options. \"-a ARG\"",
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["arg1"],
      exception_message: "Required options. \"-a ARG\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)] [default:["default value"]]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\", required: false, default: [\"default value\"]",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["default value"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -a ARG, --array=ARG              Array option description. [type:Array(String)]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithArrayRequiredFalseOnly,
  spec_dsl_lines: [
    "option \"-a ARG\", \"--array=ARG\", type: Array(String), desc: \"Array option description.\", required: false",
  ],
  spec_desc: "main command with Array(String) option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-aarray1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--array=array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a", "array1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-a", "array1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["array1"],
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-array"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["rray"],
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-a=array1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Array(String)?,
        "method" => "array",
        "expect_value" => ["=array1"],
      },
      expect_args: [] of String,
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:              ["arg1", "-a"],
      exception_message: "Option that requires an argument. \"-a\"",
    },
    {
      argv:              ["arg1", "--array"],
      exception_message: "Option that requires an argument. \"--array\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}
