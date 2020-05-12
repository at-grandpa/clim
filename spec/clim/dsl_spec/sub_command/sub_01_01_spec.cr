require "./sub"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      main command

                      Usage:

                        main [options] [arguments]

                      Options:

                        -s ARG, --string=ARG             Option test. [type:String] [default:\"default string\"]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-1      Argument description. [type:String] [default:"default argument"]

                      Sub Commands:

                        sub_1   sub_1 command
                        sub_2   sub_2 command


                    HELP_MESSAGE

  sub_1_help_message = <<-HELP_MESSAGE

                      sub_1 command

                      Usage:

                        sub_1 [options] [arguments]

                      Options:

                        -s ARG, --string=ARG             Option test. [type:String] [default:\"default string\"]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-sub-1-1      Argument description. [type:String] [default:"default argument1"]
                        02. arg-sub-1-2      Argument description. [type:String] [default:"default argument2"]

                      Sub Commands:

                        sub_sub_1   sub_sub_1 command


                    HELP_MESSAGE

  sub_sub_1_help_message = <<-HELP_MESSAGE

                      sub_sub_1 command

                      Usage:

                        sub_sub_1 [options] [arguments]

                      Options:

                        -s ARG, --string=ARG             Option test. [type:String] [default:\"default string\"]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-sub-sub-1      Argument description. [type:Bool] [default:false]


                    HELP_MESSAGE

  sub_2_help_message = <<-HELP_MESSAGE

                      sub_2 command

                      Usage:

                        sub_2 [options] [arguments]

                      Options:

                        -n ARG, --number=ARG             Option test. [type:Int32] [default:1]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-sub-2      Argument description. [type:Int32] [default:99]


                    HELP_MESSAGE
%}

spec_for_sub(
  spec_class_name: SubCommandWithDescAndUsage,
  spec_cases: [
    # ============================
    # main command
    # ============================
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "default argument",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1"],
        },
      ],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg2"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "arg2"],
        },
      ],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
      ],
    },
    {
      argv:        ["arg1", "-s", "option-value", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "option-value",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "-s", "option-value", "arg2", "arg3"],
        },
      ],
    },
    {
      argv:              ["-h"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-h\"",
      }
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
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
    # ============================
    # sub_1 command
    # ============================
    {
      argv:        ["sub_1"],
      expect_help: {{sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "default argument1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "default argument2",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1"],
      expect_help: {{sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "arg1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "default argument2",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1"],
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1", "arg2"],
      expect_help: {{sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "arg1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "arg2",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "arg2"],
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1", "arg2", "arg3"],
      expect_help: {{sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "arg1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "arg2",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg3"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1", "-s", "option-value", "arg2", "arg3"],
      expect_help: {{sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "option-value",
        },
      ],
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "arg1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "arg2",
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["arg1", "arg2", "arg3"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg3"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["arg1", "-s", "option-value", "arg2", "arg3"],
        },
      ],
    },
    {
      argv:              ["sub_1", "--help", "-ignore-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_1", "-ignore-option", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_1", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "--missing-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"--missing-option\"",
      }
    },
    {
      argv:              ["sub_1", "-m", "arg1"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "arg1", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "-m", "-d"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:        ["sub_1", "--help"],
      expect_help: {{sub_1_help_message}},
    },
    {
      argv:        ["sub_1", "--help", "ignore-arg"],
      expect_help: {{sub_1_help_message}},
    },
    {
      argv:        ["sub_1", "ignore-arg", "--help"],
      expect_help: {{sub_1_help_message}},
    },
    # ============================
    # sub_sub_1 command
    # ============================
    {
      argv:        ["sub_1", "sub_sub_1"],
      expect_help: {{sub_sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => Bool,
          "method" => "arg_sub_sub_1",
          "expect_value" => false,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_1", "sub_sub_1", "true"],
      expect_help: {{sub_sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => Bool,
          "method" => "arg_sub_sub_1",
          "expect_value" => true,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["true"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["true"],
        },
      ],
    },
    {
      argv:        ["sub_1", "sub_sub_1", "false", "true"],
      expect_help: {{sub_sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "default string",
        },
      ],
      expect_args: [
        {
          "type" => Bool,
          "method" => "arg_sub_sub_1",
          "expect_value" => false,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["false", "true"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["true"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["false", "true"],
        },
      ],
    },
    {
      argv:        ["sub_1", "sub_sub_1", "true", "-s", "option-value", "false"],
      expect_help: {{sub_sub_1_help_message}},
      expect_opts: [
        {
          "type" => String,
          "method" => "string",
          "expect_value" => "option-value",
        },
      ],
      expect_args: [
        {
          "type" => Bool,
          "method" => "arg_sub_sub_1",
          "expect_value" => true,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["true", "false"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["false"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["true", "-s", "option-value", "false"],
        },
      ],
    },
    {
      argv:              ["sub_1", "sub_sub_1", "--help", "-ignore-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "-ignore-option", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "--missing-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"--missing-option\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "-m", "arg1"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "arg1", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "-m", "-d"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "--help", "ignore-arg"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Bool arguments accept only \"true\" or \"false\". Input: [ignore-arg]",
      }
    },
    {
      argv:              ["sub_1", "sub_sub_1", "ignore-arg", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Bool arguments accept only \"true\" or \"false\". Input: [ignore-arg]",
      }
    },
    {
      argv:        ["sub_1", "sub_sub_1", "--help"],
      expect_help: {{sub_sub_1_help_message}},
    },
    # ============================
    # sub_2 command
    # ============================
    {
      argv:        ["sub_2"],
      expect_help: {{sub_2_help_message}},
      expect_opts: [
        {
          "type" => Int32,
          "method" => "number",
          "expect_value" => 1,
        },
      ],
      expect_args: [
        {
          "type" => Int32,
          "method" => "arg_sub_2",
          "expect_value" => 99,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_2", "111"],
      expect_help: {{sub_2_help_message}},
      expect_opts: [
        {
          "type" => Int32,
          "method" => "number",
          "expect_value" => 1,
        },
      ],
      expect_args: [
        {
          "type" => Int32,
          "method" => "arg_sub_2",
          "expect_value" => 111,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["111"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["111"],
        },
      ],
    },
    {
      argv:        ["sub_2", "111", "222"],
      expect_help: {{sub_2_help_message}},
      expect_opts: [
        {
          "type" => Int32,
          "method" => "number",
          "expect_value" => 1,
        },
      ],
      expect_args: [
        {
          "type" => Int32,
          "method" => "arg_sub_2",
          "expect_value" => 111,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["111", "222"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["222"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["111", "222"],
        },
      ],
    },
    {
      argv:        ["sub_2", "111", "-n", "888", "222"],
      expect_help: {{sub_2_help_message}},
      expect_opts: [
        {
          "type" => Int32,
          "method" => "number",
          "expect_value" => 888,
        },
      ],
      expect_args: [
        {
          "type" => Int32,
          "method" => "arg_sub_2",
          "expect_value" => 111,
        },
        {
          "type" => Array(String),
          "method" => "all_args",
          "expect_value" => ["111", "222"],
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["222"],
        },
        {
          "type" => Array(String),
          "method" => "argv",
          "expect_value" => ["111", "-n", "888", "222"],
        },
      ],
    },
    {
      argv:              ["sub_2",  "-ignore-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_2", "-ignore-option", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-ignore-option\"",
      }
    },
    {
      argv:              ["sub_2", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_2", "--missing-option"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"--missing-option\"",
      }
    },
    {
      argv:              ["sub_2", "-m", "arg1"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_2", "arg1", "-m"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_2", "-m", "-d"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Undefined option. \"-m\"",
      }
    },
    {
      argv:              ["sub_2", "--help", "ignore-arg"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Invalid Int32: ignore-arg",
      }
    },
    {
      argv:              ["sub_2", "ignore-arg", "--help"],
      exception_message: {
        exception: Clim::ClimInvalidOptionException,
        message:   "Invalid Int32: ignore-arg",
      }
    },
    {
      argv:        ["sub_2", "--help"],
      expect_help: {{sub_2_help_message}},
    },
  ]
)
{% end %}
