require "../dsl_spec"

spec(
  spec_class_name: MainCommandWithArray,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\"",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayOnlyShortOption,
  spec_dsl_lines: [
    "array \"-a ARG\"",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG                           Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"a" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"a" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"a" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"a" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"a" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"a" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"a" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"a" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Undefined option. \"--array\"",
      },
      {
        argv:              %w(--array attay1),
        exception_message: "Undefined option. \"--array\"",
      },
      {
        argv:              %w(--array=array1),
        exception_message: "Undefined option. \"--array=array1\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Undefined option. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayOnlyLongOption,
  spec_dsl_lines: [
    "array \"--array=ARG\"",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        --array=ARG                      Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --array array1),
        expect_opts: {"array" => ["array1"]},
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
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(-a),
        exception_message: "Undefined option. \"-a\"",
      },
      {
        argv:              %w(-a attay1),
        exception_message: "Undefined option. \"-a\"",
      },
      {
        argv:              %w(-a=array1),
        exception_message: "Undefined option. \"-a=array1\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Undefined option. \"-a\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayDesc,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\"",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv: %w(--help),
      },
      {
        argv: %w(--help ignore-arg),
      },
      {
        argv: %w(ignore-arg --help),
      },
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayDefault,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\", default: [\"default value\"]",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.  [default:["default value"]]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => ["default value"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => ["default value"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayRequiredTrueAndDefaultExists,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\", required: true, default: [\"default value\"]",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.  [default:["default value"]]  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => ["default value"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => ["default value"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayRequiredTrueOnly,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\", required: true",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
        expect_args: [] of String,
      },
      {
        argv:              %w(),
        exception_message: "Required options. \"-a ARG\"",
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
        exception_message: "Required options. \"-a ARG\"",
      },
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\", required: false, default: [\"default value\"]",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.  [default:["default value"]]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => ["default value"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => ["default value"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)

spec(
  spec_class_name: MainCommandWithArrayRequiredFalseOnly,
  spec_dsl_lines: [
    "array \"-a ARG\", \"--array=ARG\", desc: \"Array option description.\", required: false",
  ],
  spec_desc: "main command with array dsl,",
  main_help_message: <<-HELP_MESSAGE
   
                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -a ARG, --array=ARG              Array option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"array" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"array" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: {"array" => ["array1"]},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: {"array" => ["rray"]},
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: {"array" => ["=array1"]},
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
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
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
    ],
  }
)
