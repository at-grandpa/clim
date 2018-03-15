require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          -s ARG, --string=ARG             Option description.
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithString,
  spec_dsl_lines: [
    "options \"-s ARG\", \"--string=ARG\", type: String",
  ],
  spec_desc: "main command with String options,",
  spec_cases: [
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
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-sstring1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--string", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--string=string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s", "string1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-string"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "tring",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s=string1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "string",
        "expect_value" => "=string1",
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
      argv:              ["-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["--string"],
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              ["arg1", "-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["arg1", "--string"],
      exception_message: "Option that requires an argument. \"--string\"",
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

                          -s ARG                           Option description.
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithStringOnlyShortOption,
  spec_dsl_lines: [
    "options \"-s ARG\", type: String",
  ],
  spec_desc: "main command with string dsl,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => nil,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => nil,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-sstring1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s", "string1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-string"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "tring",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s=string1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String?,
        "method" => "s",
        "expect_value" => "=string1",
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
      argv:              ["-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["--string"],
      exception_message: "Undefined option. \"--string\"",
    },
    {
      argv:              ["--string", "string1"],
      exception_message: "Undefined option. \"--string\"",
    },
    {
      argv:              ["--string=string1"],
      exception_message: "Undefined option. \"--string=string1\"",
    },
    {
      argv:              ["arg1", "-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["arg1", "--string"],
      exception_message: "Undefined option. \"--string\"",
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
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           --string=ARG                     Option description.
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringOnlyLongOption,
#   spec_dsl_lines: [
#     "string \"--string=ARG\"",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        [] of String,
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => nil},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => nil},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Undefined option. \"-s\"",
#     },
#     {
#       argv:              ["-s", "string1"],
#       exception_message: "Undefined option. \"-s\"",
#     },
#     {
#       argv:              ["-s=string1"],
#       exception_message: "Undefined option. \"-s=string1\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringDesc,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\"",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.  [default:"default value"]
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringDefault,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", default: \"default value\"",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        [] of String,
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-sstring1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-string"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "tring"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s=string1"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "=string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["arg1", "-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.  [default:"default value"]  [required]
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringRequiredTrueAndDefaultExists,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: true, default: \"default value\"",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        [] of String,
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-sstring1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-string"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "tring"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s=string1"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "=string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["arg1", "-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.  [required]
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringRequiredTrueOnly,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: true",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        ["-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-sstring1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-string"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "tring"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s=string1"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "=string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:              [] of String,
#       exception_message: "Required options. \"-s ARG\"",
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["arg1"],
#       exception_message: "Required options. \"-s ARG\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["arg1", "-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.  [default:"default value"]
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringRequiredFalseAndDefaultExists,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: false, default: \"default value\"",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        [] of String,
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "default value"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-sstring1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-string"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "tring"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s=string1"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "=string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["arg1", "-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:        ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
# {% begin %}
# {%
#   main_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           main_command [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#                           -s ARG, --string=ARG             String option description.
#
#
#                       HELP_MESSAGE
# %}
#
# spec(
#   spec_class_name: MainCommandWithStringRequiredFalseOnly,
#   spec_dsl_lines: [
#     "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: false",
#   ],
#   spec_desc: "main command with string dsl,",
#   spec_cases: [
#     {
#       argv:        [] of String,
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => nil},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => nil},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-sstring1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["--string=string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s", "string1", "arg1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["arg1", "-s", "string1"],
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "string1"},
#       expect_args: ["arg1"],
#     },
#     {
#       argv:        ["-string"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "tring"},
#       expect_args: [] of String,
#     },
#     {
#       argv:        ["-s=string1"], # Unintended case.
#       expect_help: {{main_help_message}},
#       expect_opts: {"string" => "=string1"},
#       expect_args: [] of String,
#     },
#     {
#       argv:              ["-h"],
#       exception_message: "Undefined option. \"-h\"",
#     },
#     {
#       argv:              ["--help", "-ignore-option"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-ignore-option", "--help"],
#       exception_message: "Undefined option. \"-ignore-option\"",
#     },
#     {
#       argv:              ["-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:              ["arg1", "-s"],
#       exception_message: "Option that requires an argument. \"-s\"",
#     },
#     {
#       argv:              ["arg1", "--string"],
#       exception_message: "Option that requires an argument. \"--string\"",
#     },
#     {
#       argv:q       ["--help"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["--help", "ignore-arg"],
#       expect_help: {{main_help_message}},
#     },
#     {
#       argv:        ["ignore-arg", "--help"],
#       expect_help: {{main_help_message}},
#     },
#   ]
# )
# {% end %}
#
