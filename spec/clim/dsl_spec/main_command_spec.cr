require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandOnly,
  spec_dsl_lines: [] of String,
  spec_desc: "main command,",
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
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

# コンパイル時に落ちるが、テストはどうするか
# spec(
#   spec_class_name: MainCommandWithAliasName,
#   spec_dsl_lines: [
#     "alias_name \"second_name\"",
#   ],
#   spec_desc: "main command,",
#   spec_cases: [
#     {
#       argv:              [] of String,
#       exception_message: "'alias_name' is not supported on main command.",
#     },
#   ]
# )

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithDesc,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
  ],
  spec_desc: "main command,",
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
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

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithUsage,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
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

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.
                          --version                        Show version.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithVersion,
  spec_dsl_lines: [
    "version \"Version 0.9.9\"",
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
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
    {
      argv:          ["--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["--version", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:              ["-v"],
      exception_message: "Undefined option. \"-v\"",
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.
                          -v, --version                    Show version.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithVersionShort,
  spec_dsl_lines: [
    "version \"Version 0.9.9\", short: \"-v\"",
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
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
    {
      argv:          ["--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["--version", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["-v"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["-v", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "-v"],
      expect_output: "Version 0.9.9\n",
    },
  ]
)
{% end %}

# ここのテストどうするか
# class MainCommandIfCallTheMainCommandTwice < Clim
#   main_command do
#     run do |opts, args|
#     end
#   end
#
#   main_command do # Exception!!
#   end
# end
#
# describe "If the main command is called twice, " do
#   it "raises an Exception." do
#     expect_raises(Exception, "Main command is already defined.") do
#       MainCommandIfCallTheMainCommandTwice.start([] of String)
#     end
#   end
# end

#  class MainCommandWhenCallTheMainCommandTwiceInSubBlock < Clim
#    main_command
#    run do |opts, args|
#    end
#    sub do
#      main_command # Exception!!
#    end
#  end
#
#  describe "If the main command is called twice in sub block, " do
#    it "raises an Exception." do
#      expect_raises(Exception, "Main command is already defined.") do
#        MainCommandWhenCallTheMainCommandTwiceInSubBlock.start_main([] of String)
#      end
#    end
#  end
#
#  class MainCommandWhenMainCommandIsNotDefined < Clim
#    command "spec_case"
#  end
#
#  describe "Call the command," do
#    it "raises an Exception when call command method if main_command is not defined." do
#      expect_raises(Exception, "Run block of main command is not defined.") do
#        MainCommandWhenMainCommandIsNotDefined.start_main([] of String)
#      end
#    end
#  end
#
