require "./sub"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command_of_clim_library [options] [arguments]

                      Options:

                        -a ARG, --array=ARG              Option test. [type:Array(String)] [default:[\"default string\"]]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-1      Argument description. [type:String] [default:"default argument"]

                      Sub Commands:

                        sub_1   Command Line Interface Tool.
                        sub_2   Command Line Interface Tool.


                    HELP_MESSAGE

  sub_1_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        sub_1 [options] [arguments]

                      Options:

                        -a ARG, --array=ARG              Option test. [type:Array(String)] [default:[\"default string\"]]
                        --help                           Show this help.
                        -v, --version                    Show version.

                      Arguments:

                        01. arg-sub-1-1      Argument description. [type:String] [default:"default value1"]
                        02. arg-sub-1-2      Argument description. [type:String] [default:"default value2"]

                      Sub Commands:

                        sub_sub_1   Command Line Interface Tool.


                    HELP_MESSAGE
%}

spec_for_sub(
  spec_class_name: SubCommandWithDescAndUsage,
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg2"],
        },
      ],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: [
        {
          "type" => String,
          "method" => "arg_1",
          "expect_value" => "arg1",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => ["arg2", "arg3"],
        },
      ],
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
      argv:        ["sub_1"],
      expect_help: {{sub_1_help_message}},
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "default value1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "default value2",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1"],
      expect_help: {{sub_1_help_message}},
      expect_args: [
        {
          "type" => String,
          "method" => "arg_sub_1_1",
          "expect_value" => "arg1",
        },
        {
          "type" => String,
          "method" => "arg_sub_1_2",
          "expect_value" => "default value2",
        },
        {
          "type" => Array(String),
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1", "arg2"],
      expect_help: {{sub_1_help_message}},
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
          "method" => "unknown_args",
          "expect_value" => [] of String,
        },
      ],
    },
    {
      argv:        ["sub_1", "arg1", "arg2", "arg3"],
      expect_help: {{sub_1_help_message}},
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
          "method" => "unknown_args",
          "expect_value" => ["arg3"],
        },
      ],
    },
    {
      argv:              ["sub_1", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_1", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_1", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["sub_1", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_1", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_1", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
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
        sub "sub_1" do
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
