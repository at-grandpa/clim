require "../../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE
                      command description: Command Line Interface Tool.
                      command usage: main_command_of_clim_library [options] [arguments]

                      options:
                      a
                      b
                      c

                      HELP_MESSAGE
%}

spec(
  spec_class_name: OptionTypeSpec,
  spec_dsl_lines: [
    <<-CUSTOM_HELP
    custom_help do |desc, usage, options_help|
      <<-MY_HELP
      command description: \#{desc}
      command usage: \#{usage}

      options:
      \#{options_help.join("\n")}
      MY_HELP
    end
    CUSTOM_HELP,
  ],
  spec_desc: "option type spec,",
  spec_cases: [
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}
