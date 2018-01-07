require "./../../spec_helper"
require "../dsl_spec"

spec(
  spec_class_name: MainCommandWithString,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             Option description.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"string" => nil},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => nil},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringOnlyShortOption,
  spec_dsl_lines: [
    "string \"-s ARG\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG                           Option description.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"s" => nil},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"s" => nil},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"s" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"s" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"s" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"s" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"s" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"s" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Undefined option. \"--string\"",
    },
    {
      argv:              %w(--string string1),
      exception_message: "Undefined option. \"--string\"",
    },
    {
      argv:              %w(--string=string1),
      exception_message: "Undefined option. \"--string=string1\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Undefined option. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringOnlyLongOption,
  spec_dsl_lines: [
    "string \"--string=ARG\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    --string=ARG                     Option description.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"string" => nil},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => nil},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 --string string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Undefined option. \"-s\"",
    },
    {
      argv:              %w(-s string1),
      exception_message: "Undefined option. \"-s\"",
    },
    {
      argv:              %w(-s=string1),
      exception_message: "Undefined option. \"-s=string1\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringDesc,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringDefault,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", default: \"default value\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.  [default:"default value"]


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:        %w(),
      expect_opts: {"string" => "default value"},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => "default value"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringRequiredTrueAndDefaultExists,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: true, default: \"default value\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.  [default:"default value"]  [required]


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"string" => "default value"},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => "default value"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringRequiredTrueOnly,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: true",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.  [required]


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(),
      exception_message: "Required options. \"-s ARG\"",
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(arg1),
      exception_message: "Required options. \"-s ARG\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: false, default: \"default value\"",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.  [default:"default value"]


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"string" => "default value"},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => "default value"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)

spec(
  spec_class_name: MainCommandWithStringRequiredFalseOnly,
  spec_dsl_lines: [
    "string \"-s ARG\", \"--string=ARG\", desc: \"String option description.\", required: false",
  ],
  spec_desc: "main command with string dsl,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.
                    -s ARG, --string=ARG             String option description.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: {"string" => nil},
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: {"string" => nil},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-s string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-sstring1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(--string=string1),
      expect_opts: {"string" => "string1"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s string1 arg1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 -s string1),
      expect_opts: {"string" => "string1"},
      expect_args: ["arg1"],
    },
    {
      argv:        %w(-string), # Unintended case.
      expect_opts: {"string" => "tring"},
      expect_args: [] of String,
    },
    {
      argv:        %w(-s=string1), # Unintended case.
      expect_opts: {"string" => "=string1"},
      expect_args: [] of String,
    },
    {
      argv:              %w(-h),
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              %w(--help -ignore-option),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-ignore-option --help),
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              %w(-s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(--string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              %w(arg1 -s),
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              %w(arg1 --string),
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv: %w(--help),
    },
    {
      argv: %w(--help ignore-arg),
    },
    {
      argv: %w(ignore-arg --help),
    },
  ]
)
