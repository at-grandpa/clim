require "../dsl_spec"

spec(
  spec_class_name: MainCommandWithArray,
  spec_dsl_lines: [] of String,
  spec_desc: "main command,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 arg2),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        %w(arg1 arg2 arg3),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              %w(-m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(--missing-option),
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              %w(-m arg1),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(arg1 -m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(-m -d),
      exception_message: "Undefined option. \"-m\"",
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
  ]
)

spec(
  spec_class_name: MainCommandWithAliasName,
  spec_dsl_lines: [
    "alias_name \"second_name\"",
  ],
  spec_desc: "main command,",
  help_message: <<-HELP_MESSAGE

                  Command Line Interface Tool.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:              %w(),
      exception_message: "'alias_name' is not supported on main command.",
    },
  ]
)

spec(
  spec_class_name: MainCommandWithDesc,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
  ],
  spec_desc: "main command,",
  help_message: <<-HELP_MESSAGE

                  Main command with desc.

                  Usage:

                    main_command [options] [arguments]

                  Options:

                    --help                           Show this help.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 arg2),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        %w(arg1 arg2 arg3),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              %w(-m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(--missing-option),
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              %w(-m arg1),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(arg1 -m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(-m -d),
      exception_message: "Undefined option. \"-m\"",
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
  ]
)

spec(
  spec_class_name: MainCommandWithUsage,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
  help_message: <<-HELP_MESSAGE

                  Main command with desc.

                  Usage:

                    main_command with usage [options] [arguments]

                  Options:

                    --help                           Show this help.


                HELP_MESSAGE,
  spec_cases: [
    {
      argv:        %w(),
      expect_opts: ReturnOptsType.new,
      expect_args: [] of String,
    },
    {
      argv:        %w(arg1),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1"],
    },
    {
      argv:        %w(arg1 arg2),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        %w(arg1 arg2 arg3),
      expect_opts: ReturnOptsType.new,
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              %w(-m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(--missing-option),
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              %w(-m arg1),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(arg1 -m),
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              %w(-m -d),
      exception_message: "Undefined option. \"-m\"",
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
  ]
)

class MainCommand::IfCallTheMainCommandTwice < Clim
  main_command
  run do |opts, args|
  end

  main_command # Exception!!
end

describe "If the main command is called twice, " do
  it "raises an Exception." do
    expect_raises(Exception, "Main command is already defined.") do
      MainCommand::IfCallTheMainCommandTwice.start_main([] of String)
    end
  end
end

class MainCommandWhenCallTheMainCommandTwiceInSubBlock < Clim
  main_command
  run do |opts, args|
  end
  sub do
    main_command # Exception!!
  end
end

describe "If the main command is called twice in sub block, " do
  it "raises an Exception." do
    expect_raises(Exception, "Main command is already defined.") do
      MainCommandWhenCallTheMainCommandTwiceInSubBlock.start_main([] of String)
    end
  end
end

class MainCommandWhenMainCommandIsNotDefined < Clim
  command "spec_case"
end

describe "Call the main command twice." do
  it "raises an Exception when call command method if main_command is not defined." do
    expect_raises(Exception, "Main command is not defined.") do
      MainCommandWhenMainCommandIsNotDefined.start_main([] of String)
    end
  end
end
