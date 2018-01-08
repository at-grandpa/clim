require "../dsl_spec"

spec(
  spec_class_name: MainCommandWithBool,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
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
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
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
  spec_class_name: MainCommandWithBoolOnlyShortOption,
  spec_dsl_lines: [
    "bool \"-b\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b                               Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"b" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"b" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"b" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"b" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"b" => true},
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
        argv:              %w(--bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool=ARG),
        exception_message: "Undefined option. \"--bool=ARG\"",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
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
  spec_class_name: MainCommandWithBoolOnlyLongOption,
  spec_dsl_lines: [
    "bool \"--bool\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        --bool                           Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
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
        argv:              %w(-b),
        exception_message: "Undefined option. \"-b\"",
      },
      {
        argv:              %w(-b=ARG),
        exception_message: "Undefined option. \"-b=ARG\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
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
  spec_class_name: MainCommandWithBoolArguments,
  spec_dsl_lines: [
    "bool \"-b ARG\", \"--bool=ARG\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG, --bool=ARG               Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
  spec_class_name: MainCommandWithBoolArgumentsOnlyShortOption,
  spec_dsl_lines: [
    "bool \"-b ARG\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG                           Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"b" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"b" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: {"b" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: {"b" => false},
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool true),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool false),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Undefined option. \"--bool=arg1\"",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
  spec_class_name: MainCommandWithBoolArgumentsOnlyLongOption,
  spec_dsl_lines: [
    "bool \"--bool=ARG\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        --bool=ARG                       Option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool=true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool=false),
        expect_opts: {"bool" => false},
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
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b),
        exception_message: "Undefined option. \"-b\"",
      },
      {
        argv:              %w(-b true),
        exception_message: "Undefined option. \"-b\"",
      },
      {
        argv:              %w(-b false),
        exception_message: "Undefined option. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Undefined option. \"-b\"",
      },
      {
        argv:              %w(--bool arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
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
  spec_class_name: MainCommandWithBoolDesc,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\"",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.


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
  spec_class_name: MainCommandWithBoolDefault,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\", default: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.  [default:false]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
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
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
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
  spec_class_name: MainCommandWithBoolRequiredTrueAndDefaultExists,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\", required: true, default: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.  [default:false]  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
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
  spec_class_name: MainCommandWithBoolArgumentsRequiredTrueAndDefaultExists,
  spec_dsl_lines: [
    "bool \"-b ARG\", \"--bool=ARG\", desc: \"Bool option description.\", required: true, default: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG, --bool=ARG               Bool option description.  [default:false]  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: {"bool" => false},
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
  spec_class_name: SpecMainCommandWithBoolRequiredTrueOnly,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\", required: true",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
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
        argv:              %w(),
        exception_message: "Required options. \"-b\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-b\"",
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
  spec_class_name: MainCommandWithBoolArgumentsRequiredTrueOnly,
  spec_dsl_lines: [
    "bool \"-b ARG\", \"--bool=ARG\", desc: \"Bool option description.\", required: true",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG, --bool=ARG               Bool option description.  [required]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(-b true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:              %w(),
        exception_message: "Required options. \"-b ARG\"",
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
        exception_message: "Required options. \"-b ARG\"",
      },
      {
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
  spec_class_name: MainCommandWithBoolRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\", required: false, default: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.  [default:false]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
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
  spec_class_name: MainCommandWithBoolArgumentsRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "bool \"-b ARG\", \"--bool=ARG\", desc: \"Bool option description.\", required: false, default: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG, --bool=ARG               Bool option description.  [default:false]


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: {"bool" => false},
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
  spec_class_name: MainCommandWithBoolRequiredFalseOnly,
  spec_dsl_lines: [
    "bool \"-b\", \"--bool\", desc: \"Bool option description.\", required: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b, --bool                       Bool option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
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
  spec_class_name: MainCommandWithBoolArgumentsRequiredFalseOnly,
  spec_dsl_lines: [
    "bool \"-b ARG\", \"--bool=ARG\", desc: \"Bool option description.\", required: false",
  ],
  spec_desc: "main command with bool dsl,",
  main_help_message: <<-HELP_MESSAGE
   
                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.
                        -b ARG, --bool=ARG               Bool option description.


                    HELP_MESSAGE,
  spec_cases_hash: {
    main_command_case: [
      {
        argv:        %w(),
        expect_opts: {"bool" => nil},
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: {"bool" => nil},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: {"bool" => true},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: {"bool" => true},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: {"bool" => false},
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: {"bool" => false},
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: {"bool" => false},
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
