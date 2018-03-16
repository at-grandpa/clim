require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBool,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
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
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Undefined option. \"-bool\"",
    },
    {
      argv: ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv: ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv: ["ignore-arg", "--help"],
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b                               Option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolOnlyShortOption,
  spec_dsl_lines: [
    "option \"-b\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => true,
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
      argv:              ["--bool"],
      exception_message: "Undefined option. \"--bool\"",
    },
    {
      argv:              ["--bool=ARG"],
      exception_message: "Undefined option. \"--bool=ARG\"",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Undefined option. \"-bool\"",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          --bool                           Option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolOnlyLongOption,
  spec_dsl_lines: [
    "option \"--bool\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
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
      argv:              ["-b"],
      exception_message: "Undefined option. \"-b\"",
    },
    {
      argv:              ["-b=ARG"],
      exception_message: "Undefined option. \"-b=ARG\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Undefined option. \"-bool\"",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b ARG, --bool=ARG               Option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolArguments,
  spec_dsl_lines: [
    "option \"-b ARG\", \"--bool=ARG\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
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
      argv:              ["-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["arg1", "-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["arg1", "--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["-b", "arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--bool=arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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

                         main_command_of_clim_library [options] [arguments]

                       Options:

                         -b ARG                           Option description. [type:Bool] [default:false]
                         --help                           Show this help.


                     HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolArgumentsOnlyShortOption,
  spec_dsl_lines: [
    "option \"-b ARG\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "b",
        "expect_value" => false,
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
      argv:              ["-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["--bool"],
      exception_message: "Undefined option. \"--bool\"",
    },
    {
      argv:              ["--bool", "true"],
      exception_message: "Undefined option. \"--bool\"",
    },
    {
      argv:              ["--bool", "false"],
      exception_message: "Undefined option. \"--bool\"",
    },
    {
      argv:              ["arg1", "-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["arg1", "--bool"],
      exception_message: "Undefined option. \"--bool\"",
    },
    {
      argv:              ["-b", "arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--bool=arg1"],
      exception_message: "Undefined option. \"--bool=arg1\"",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          --bool=ARG                       Option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolArgumentsOnlyLongOption,
  spec_dsl_lines: [
    "option \"--bool=ARG\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool=true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool=false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
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
      argv:              ["--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["-b"],
      exception_message: "Undefined option. \"-b\"",
    },
    {
      argv:              ["-b", "true"],
      exception_message: "Undefined option. \"-b\"",
    },
    {
      argv:              ["-b", "false"],
      exception_message: "Undefined option. \"-b\"",
    },
    {
      argv:              ["arg1", "--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["arg1", "-b"],
      exception_message: "Undefined option. \"-b\"",
    },
    {
      argv:              ["--bool", "arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolDesc,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool, desc: \"Bool option description.\"",
  ],
  spec_desc: "main command with Bool option,",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolDefault,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool, desc: \"Bool option description.\", default: false",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
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
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Undefined option. \"-bool\"",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool, desc: \"Bool option description.\", required: false, default: false",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b ARG, --bool=ARG               Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolArgumentsRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "option \"-b ARG\", \"--bool=ARG\", type: Bool, desc: \"Bool option description.\", required: false, default: false",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "true", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "false", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "true", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "false", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
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
      argv:              ["-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["arg1", "-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["arg1", "--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["-b", "arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--bool=arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
 %}

 spec(
  spec_class_name: MainCommandWithBoolRequiredFalseOnly,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool, desc: \"Bool option description.\", required: false",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
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

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b ARG, --bool=ARG               Bool option description. [type:Bool] [default:false]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBoolArgumentsRequiredFalseOnly,
  spec_dsl_lines: [
    "option \"-b ARG\", \"--bool=ARG\", type: Bool, desc: \"Bool option description.\", required: false",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "true", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "false", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "true", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool", "true"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool", "false", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool", "false"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool?,
        "method" => "bool",
        "expect_value" => false,
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
      argv:              ["-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["arg1", "-b"],
      exception_message: "Option that requires an argument. \"-b\"",
    },
    {
      argv:              ["arg1", "--bool"],
      exception_message: "Option that requires an argument. \"--bool\"",
    },
    {
      argv:              ["-b", "arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--bool=arg1"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
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
