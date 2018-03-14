require "../dsl_spec"

macro spec_for_sub_commands(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub_command "sub_command" do
          desc "Sub command with desc."
          usage "sub_command with usage [options] [arguments]"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
        end
      end
    end

    # spec
    describe "sub command with desc and usage," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

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

                       --help                           Show this help.


                   HELP_MESSAGE
%}

spec_for_sub_commands(
  spec_class_name: SubCommandWithDescAndUsage,
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
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
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "arg1"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
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

macro spec_for_sub_sub_commands(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub_command "sub_command" do
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub_command "sub_sub_command" do
            run do |opts, args|
              assert_opts_and_args({{spec_case}})
            end
          end
        end
      end
    end

    # spec
    describe "sub sub command," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command [options] [arguments]

                      Options:

                        --help                           Show this help.

                      Sub Commands:

                        sub_command   Command Line Interface Tool.


                    HELP_MESSAGE

  sub_help_message = <<-HELP_MESSAGE

                     Command Line Interface Tool.

                     Usage:

                       sub_command [options] [arguments]

                     Options:

                       --help                           Show this help.

                     Sub Commands:

                       sub_sub_command   Command Line Interface Tool.


                   HELP_MESSAGE

  sub_sub_help_message = <<-HELP_MESSAGE

                         Command Line Interface Tool.

                         Usage:

                           sub_sub_command [options] [arguments]

                         Options:

                           --help                           Show this help.


                       HELP_MESSAGE
%}

spec_for_sub_sub_commands(
  spec_class_name: SubSubCommandOnly,
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
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
    {
      argv:        ["sub_command"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "arg1"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
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
    {
      argv:        ["sub_command", "sub_sub_command"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1", "arg2"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:              ["sub_command", "sub_sub_command", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["sub_command", "sub_sub_command", "--help"],
      expect_help: {{sub_sub_help_message}},
    },
    {
      argv:        ["sub_command", "sub_sub_command", "--help", "ignore-arg"],
      expect_help: {{sub_sub_help_message}},
    },
    {
      argv:        ["sub_command", "sub_sub_command", "ignore-arg", "--help"],
      expect_help: {{sub_sub_help_message}},
    },
  ]
)
{% end %}

macro spec_for_jump_over_sub_sub_command(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        command "sub_command" do
          run do |opts, args|
          end
          command "sub_sub_command" do
            run do |opts, args|
              assert_opts_and_args({{spec_case}})
            end
          end
        end
        command "jump_over_sub_sub_command" do
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
        end
      end
    end

    # spec
    describe "jump over sub_sub command," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command [options] [arguments]

                        Options:

                          --help                           Show this help.

                        Sub Commands:

                          sub_command                 Command Line Interface Tool.
                          jump_over_sub_sub_command   Command Line Interface Tool.


                      HELP_MESSAGE

  sub_sub_help_message = <<-HELP_MESSAGE

                           Command Line Interface Tool.

                           Usage:

                             sub_sub_command [options] [arguments]

                           Options:

                             --help                           Show this help.


                         HELP_MESSAGE

  jump_over_sub_sub_help_message = <<-HELP_MESSAGE

                                     Command Line Interface Tool.

                                     Usage:

                                       jump_over_sub_sub_command [options] [arguments]

                                     Options:

                                       --help                           Show this help.


                                   HELP_MESSAGE
%}

spec_for_jump_over_sub_sub_command(
  spec_class_name: JumpOverSubSubCommand,
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_opts: ReturnOptsType.new,
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
      argv:        ["sub_command", "sub_sub_command"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1", "arg2"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "sub_sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:              ["sub_command", "sub_sub_command", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "sub_sub_command", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["sub_command", "sub_sub_command", "--help"],
      expect_help: {{sub_sub_help_message}},
    },
    {
      argv:        ["sub_command", "sub_sub_command", "--help", "ignore-arg"],
      expect_help: {{sub_sub_help_message}},
    },
    {
      argv:        ["sub_command", "sub_sub_command", "ignore-arg", "--help"],
      expect_help: {{sub_sub_help_message}},
    },
    {
      argv:        ["jump_over_sub_sub_command"],
      expect_help: {{jump_over_sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        ["jump_over_sub_sub_command", "arg1"],
      expect_help: {{jump_over_sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        ["jump_over_sub_sub_command", "arg1", "arg2"],
      expect_help: {{jump_over_sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["jump_over_sub_sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{jump_over_sub_sub_help_message}},
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:              ["jump_over_sub_sub_command", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["jump_over_sub_sub_command", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["jump_over_sub_sub_command", "--help"],
      expect_help: {{jump_over_sub_sub_help_message}},
    },
    {
      argv:        ["jump_over_sub_sub_command", "--help", "ignore-arg"],
      expect_help: {{jump_over_sub_sub_help_message}},
    },
    {
      argv:        ["jump_over_sub_sub_command", "ignore-arg", "--help"],
      expect_help: {{jump_over_sub_sub_help_message}},
    },
  ]
)
{% end %}

#macro spec_for_alias_name(spec_class_name, spec_cases)
#  {% for spec_case, index in spec_cases %}
#    {% class_name = (spec_class_name.stringify + index.stringify).id %}
#
#    # define dsl
#    class {{class_name}} < Clim
#      main_command
#      run do |opts, args|
#        assert_opts_and_args({{spec_case}})
#      end
#
#      sub do
#        command "sub_command_1"
#        alias_name "alias_sub_command_1"
#        run do |opts, args|
#          assert_opts_and_args({{spec_case}})
#        end
#
#        sub do
#          command "sub_sub_command_1"
#          run do |opts, args|
#          end
#        end
#
#        command "sub_command_2"
#        alias_name "alias_sub_command_2", "alias_sub_command_2_second"
#        run do |opts, args|
#          assert_opts_and_args({{spec_case}})
#        end
#      end
#    end
#
#    # spec
#    describe "alias name case," do
#      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
#        it_blocks({{class_name}}, {{spec_case}})
#      end
#    end
#  {% end %}
#end
#
#{% begin %}
#{%
#  main_help_message = <<-HELP_MESSAGE
#
#                        Command Line Interface Tool.
#
#                        Usage:
#
#                          main_command [options] [arguments]
#
#                        Options:
#
#                          --help                           Show this help.
#
#                        Sub Commands:
#
#                          sub_command_1, alias_sub_command_1                               Command Line Interface Tool.
#                          sub_command_2, alias_sub_command_2, alias_sub_command_2_second   Command Line Interface Tool.
#
#
#                      HELP_MESSAGE
#
#  sub_1_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           sub_command_1 [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#
#                         Sub Commands:
#
#                           sub_sub_command_1   Command Line Interface Tool.
#
#
#                       HELP_MESSAGE
#
#  sub_2_help_message = <<-HELP_MESSAGE
#
#                         Command Line Interface Tool.
#
#                         Usage:
#
#                           sub_command_2 [options] [arguments]
#
#                         Options:
#
#                           --help                           Show this help.
#
#
#                       HELP_MESSAGE
#%}
#
#spec_for_alias_name(
#  spec_class_name: SubCommandWithAliasName,
#  spec_cases: [
#    {
#      argv:        [] of String,
#      expect_help: {{main_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["arg1"],
#      expect_help: {{main_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["arg1", "arg2"],
#      expect_help: {{main_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["arg1", "arg2", "arg3"],
#      expect_help: {{main_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:              ["-h"],
#      exception_message: "Undefined option. \"-h\"",
#    },
#    {
#      argv:              ["--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:        ["--help"],
#      expect_help: {{main_help_message}},
#    },
#    {
#      argv:        ["--help", "ignore-arg"],
#      expect_help: {{main_help_message}},
#    },
#    {
#      argv:        ["ignore-arg", "--help"],
#      expect_help: {{main_help_message}},
#    },
#    {
#      argv:        ["sub_command_1"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["alias_sub_command_1"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["sub_command_1", "arg1"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["alias_sub_command_1", "arg1"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["sub_command_1", "arg1", "arg2"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["alias_sub_command_1", "arg1", "arg2"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["sub_command_1", "arg1", "arg2", "arg3"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:        ["alias_sub_command_1", "arg1", "arg2", "arg3"],
#      expect_help: {{sub_1_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:              ["sub_command_1", "--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["sub_command_1", "-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["sub_command_1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_1", "--missing-option"],
#      exception_message: "Undefined option. \"--missing-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "--missing-option"],
#      exception_message: "Undefined option. \"--missing-option\"",
#    },
#    {
#      argv:              ["sub_command_1", "-m", "arg1"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "-m", "arg1"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_1", "arg1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "arg1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_1", "-m", "-d"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_1", "-m", "-d"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:        ["sub_command_1", "--help"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_1", "--help"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["sub_command_1", "--help", "ignore-arg"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_1", "--help", "ignore-arg"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["sub_command_1", "ignore-arg", "--help"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_1", "ignore-arg", "--help"],
#      expect_help: {{sub_1_help_message}},
#    },
#    {
#      argv:        ["sub_command_2"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["alias_sub_command_2"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["alias_sub_command_2_second"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: [] of String,
#    },
#    {
#      argv:        ["sub_command_2", "arg1"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["alias_sub_command_2", "arg1"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "arg1"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1"],
#    },
#    {
#      argv:        ["sub_command_2", "arg1", "arg2"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["alias_sub_command_2", "arg1", "arg2"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "arg1", "arg2"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2"],
#    },
#    {
#      argv:        ["sub_command_2", "arg1", "arg2", "arg3"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:        ["alias_sub_command_2", "arg1", "arg2", "arg3"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "arg1", "arg2", "arg3"],
#      expect_help: {{sub_2_help_message}},
#      expect_opts: ReturnOptsType.new,
#      expect_args: ["arg1", "arg2", "arg3"],
#    },
#    {
#      argv:              ["sub_command_2", "--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "--help", "-ignore-option"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["sub_command_2", "-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "-ignore-option", "--help"],
#      exception_message: "Undefined option. \"-ignore-option\"",
#    },
#    {
#      argv:              ["sub_command_2", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_2", "--missing-option"],
#      exception_message: "Undefined option. \"--missing-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "--missing-option"],
#      exception_message: "Undefined option. \"--missing-option\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "--missing-option"],
#      exception_message: "Undefined option. \"--missing-option\"",
#    },
#    {
#      argv:              ["sub_command_2", "-m", "arg1"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "-m", "arg1"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "-m", "arg1"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_2", "arg1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "arg1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "arg1", "-m"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["sub_command_2", "-m", "-d"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2", "-m", "-d"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:              ["alias_sub_command_2_second", "-m", "-d"],
#      exception_message: "Undefined option. \"-m\"",
#    },
#    {
#      argv:        ["sub_command_2", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["sub_command_2", "--help", "ignore-arg"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2", "--help", "ignore-arg"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "--help", "ignore-arg"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["sub_command_2", "ignore-arg", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2", "ignore-arg", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#    {
#      argv:        ["alias_sub_command_2_second", "ignore-arg", "--help"],
#      expect_help: {{sub_2_help_message}},
#    },
#  ]
#)
#{% end %}
#
#class SubCommandWhenDuplicateCommandName < Clim
#  main_command
#  run do |opts, args|
#  end
#
#  sub do
#    command "sub_command"
#    run do |opts, args|
#    end
#
#    command "sub_command" # Duplicate name.
#    run do |opts, args|
#    end
#  end
#end
#
#describe "Call the command." do
#  it "raises an Exception when duplicate command name." do
#    expect_raises(Exception, "There are duplicate registered commands. [sub_command]") do
#      SubCommandWhenDuplicateCommandName.start_main([] of String)
#    end
#  end
#end
#
#class SubCommandWhenDuplicateAliasNameCase1 < Clim
#  main_command
#  run do |opts, args|
#  end
#
#  sub do
#    command "sub_command"
#    alias_name "sub_command" # duplicate
#    run do |opts, args|
#    end
#  end
#end
#
#describe "Call the command." do
#  it "raises an Exception when duplicate command name (case1)." do
#    expect_raises(Exception, "There are duplicate registered commands. [sub_command]") do
#      SubCommandWhenDuplicateAliasNameCase1.start_main([] of String)
#    end
#  end
#end
#
#class SubCommandWhenDuplicateAliasNameCase2 < Clim
#  main_command
#  run do |opts, args|
#  end
#
#  sub do
#    command "sub_command1"
#    alias_name "sub_command1", "sub_command2", "sub_command2" # duplicate "sub_command1" and "sub_command2"
#    run do |opts, args|
#    end
#  end
#end
#
#describe "Call the command." do
#  it "raises an Exception when duplicate command name (case2)." do
#    expect_raises(Exception, "There are duplicate registered commands. [sub_command1,sub_command2]") do
#      SubCommandWhenDuplicateAliasNameCase2.start_main([] of String)
#    end
#  end
#end
#
#class SubCommandWhenDuplicateAliasNameCase3 < Clim
#  main_command
#  run do |opts, args|
#  end
#
#  sub do
#    command "sub_command1"
#    alias_name "alias_name1"
#    run do |opts, args|
#    end
#
#    command "sub_command2"
#    alias_name "alias_name2"
#    run do |opts, args|
#    end
#
#    command "sub_command3"
#    alias_name "sub_command1", "sub_command2", "alias_name1", "alias_name2"
#    run do |opts, args|
#    end
#  end
#end
#
#describe "Call the command." do
#  it "raises an Exception when duplicate command name (case3)." do
#    expect_raises(Exception, "There are duplicate registered commands. [sub_command1,sub_command2,alias_name1,alias_name2]") do
#      SubCommandWhenDuplicateAliasNameCase3.start_main([] of String)
#    end
#  end
#end
#