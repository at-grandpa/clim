require "./sub_test"

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

                       --help                           Show this help.


                   HELP_MESSAGE
%}

spec_for_sub(
  spec_class_name: SubCommandWithDescAndUsage,
  spec_cases: [
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
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
        sub "sub_command" do
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub "sub_sub_command" do
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
