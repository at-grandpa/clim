require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command_of_clim_library [options] [arguments]

                      Options:

                        --help                           Show this help.

                      Sub Commands:

                        sub_command   Sub command with desc.


                    HELP_MESSAGE

  sub_help_message = <<-HELP_MESSAGE

                     Sub command with desc.

                     Usage:

                       sub_command with usage [options] [arguments]

                     Options:

                       -a ARG, --array=ARG              Option test. [type:Array(String)] [default:["default string"]]
                       --help                           Show this help.
                       -v, --version                    Show version.


                   HELP_MESSAGE
%}

spec(
  spec_class_name: SubCommandWithDescUsageVersionOption,
  spec_sub_command_lines: [
    <<-SUB_COMMAND,
    sub_command "sub_command" do
      desc "Sub command with desc."
      usage "sub_command with usage [options] [arguments]"
      version "version 1.0.0", short: "-v"
      option "-a ARG", "--array=ARG", desc: "Option test.", type: Array(String), default: ["default string"]
      run do |options, arguments|
      end
    end
    SUB_COMMAND
  ],
  spec_desc: "option type spec,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
    {
      argv:        ["sub_command"],
      expect_help: {{sub_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "arg1"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:           ["sub_command", "--version"],
      expect_version: "version 1.0.0\n",
    },
    {
      argv:           ["sub_command", "-v"],
      expect_version: "version 1.0.0\n",
    },
    {
      argv:              ["sub_command", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["sub_command", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["sub_command", "--help"],
      expect_help: {{sub_help_message}},
    },
    {
      argv:        ["sub_command", "--help", "ignore-arg"],
      expect_help: {{sub_help_message}},
    },
    {
      argv:        ["sub_command", "ignore-arg", "--help"],
      expect_help: {{sub_help_message}},
    },
  ]
)
{% end %}
