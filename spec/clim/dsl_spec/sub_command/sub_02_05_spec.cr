require "../../dsl_spec"

macro spec_for_alias_name(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub "sub_command_1" do
          alias_name "alias_sub_command_1"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub "sub_sub_command_1" do
            run do |opts, args|
            end
          end
        end
        sub "sub-command-2" do
          alias_name "alias-sub-command-2", "alias-sub-command-2-second"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
        end
      end
    end

    # spec
    describe "alias name case," do
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

                          main_of_clim_library [options] [arguments]

                        Options:

                          --help                           Show this help.

                        Sub Commands:

                          sub_command_1, alias_sub_command_1                               Command Line Interface Tool.
                          sub-command-2, alias-sub-command-2, alias-sub-command-2-second   Command Line Interface Tool.


                      HELP_MESSAGE

  sub_1_help_message = <<-HELP_MESSAGE

                         Command Line Interface Tool.

                         Usage:

                           sub_command_1 [options] [arguments]

                         Options:

                           --help                           Show this help.

                         Sub Commands:

                           sub_sub_command_1   Command Line Interface Tool.


                       HELP_MESSAGE

  sub_2_help_message = <<-HELP_MESSAGE

                         Command Line Interface Tool.

                         Usage:

                           sub-command-2 [options] [arguments]

                         Options:

                           --help                           Show this help.


                       HELP_MESSAGE
%}

spec_for_alias_name(
  spec_class_name: SubCommandWithAliasName,
  spec_cases: [
    {
      argv:        ["sub-command-2", "--help"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2", "--help"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2-second", "--help"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["sub-command-2", "--help", "ignore-arg"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2", "--help", "ignore-arg"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2-second", "--help", "ignore-arg"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["sub-command-2", "ignore-arg", "--help"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2", "ignore-arg", "--help"],
      expect_help: {{sub_2_help_message}},
    },
    {
      argv:        ["alias-sub-command-2-second", "ignore-arg", "--help"],
      expect_help: {{sub_2_help_message}},
    },
  ]
)
{% end %}
