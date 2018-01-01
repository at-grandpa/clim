require "./../../spec_helper"
require "../dsl_spec"

class SpecMainCommandOnly < Clim
  main_command
  run do |opts, args|
  end
end

describe "main command only." do
  describe "returns help." do
    [
      {
        argv: %w(--help),
      },
      {
        argv: %w(--help ignore-arg),
      },
      {
        argv: %w(ignore-arg --help),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Command Line Interface Tool.

            Usage:

              main_command [options] [arguments]

            Options:

              --help                           Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_opts_hash,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_opts_hash,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
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
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithAliasName < Clim
  # For the spec case, please see the "it" block below.
end

describe "Call the main command with alias_name." do
  it "raises an Exception." do
    expect_raises(Exception, "'alias_name' is not supported on main command.") do
      #
      # spec case:
      #
      #  class SpecClass
      #    main_command
      #    alias_name "second_name"
      #    run do |opts, args|
      #    end
      #  end
      #
      SpecMainCommandWithAliasName.main_command
      SpecMainCommandWithAliasName.alias_name "second_name"
      SpecMainCommandWithAliasName.run do |opts, args|
      end
    end
  end
end

class SpecMainCommandWithDesc < Clim
  main_command
  desc "Main command with desc."
  run do |opts, args|
  end
end

describe "main command with desc." do
  describe "returns help." do
    [
      {
        argv: %w(--help),
      },
      {
        argv: %w(--help ignore-arg),
      },
      {
        argv: %w(ignore-arg --help),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithDesc.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command [options] [arguments]

            Options:

              --help                           Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_opts_hash,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_opts_hash,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithDesc.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
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
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithDesc.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithUsage < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with usage." do
  describe "returns help." do
    [
      {
        argv: %w(--help),
      },
      {
        argv: %w(--help ignore-arg),
      },
      {
        argv: %w(ignore-arg --help),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithUsage.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_opts_hash,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_opts_hash,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_opts_hash,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithUsage.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
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
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithUsage.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithEmptyShortOption < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with empty option." do
  it "raises an Exception when short option is empty if short & long option exists. [string]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.string "", "--s1=S1"
    end
  end
  it "raises an Exception when short option is empty if short & long option exists. [bool]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.bool "", "--b1=B1"
    end
  end
  it "raises an Exception when short option is empty if short & long option exists. [array]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.array "", "--a1=A1"
    end
  end
  it "raises an Exception when short option is empty if short option only. [string]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.string ""
    end
  end
  it "raises an Exception when short option is empty if short option only. [bool]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.bool ""
    end
  end
  it "raises an Exception when short option is empty if short option only. [array]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.array ""
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionStringAndArray < Clim
  # Default setting only.
  # For the spec case, please see the "it" block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [string & array]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-a\"") do
      #
      # spec case:
      #
      #   string "-a A1", "--a1=A1"
      #   array "-a A2", "--a2=A2"
      #
      SpecMainCommandWithDuplicateShortOptionStringAndArray.string "-a A1", "--a1=A1"
      SpecMainCommandWithDuplicateShortOptionStringAndArray.array "-a A2", "--a2=A2"
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionStringAndBool < Clim
  # Default setting only.
  # For the spec case, please see the "it" block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [string & bool]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-b\"") do
      #
      # spec case:
      #
      #   string "-b B1", "--b1=B1"
      #   bool "-b", "--b2"
      #
      SpecMainCommandWithDuplicateShortOptionStringAndBool.string "-b B1", "--b1=B1"
      SpecMainCommandWithDuplicateShortOptionStringAndBool.bool "-b", "--b2"
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionArrayAndBool < Clim
  # Default setting only.
  # For the spec case, please see the "it" block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [array & bool]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-c\"") do
      #
      # spec case:
      #
      #   array "-c C1", "--c1=C1"
      #   bool "-c", "--c2"
      #
      SpecMainCommandWithDuplicateShortOptionStringAndBool.array "-c C1", "--c1=C1"
      SpecMainCommandWithDuplicateShortOptionStringAndBool.bool "-c", "--c2"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionStringAndArray < Clim
  # Default setting only.
  # For the spec case, please see the "it" block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [string & array]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      #
      # spec case:
      #
      #   string "-a A1", "--duplicate=A1"
      #   array "-b B1", "--duplicate=B1"
      #
      SpecMainCommandWithDuplicateLongOptionStringAndArray.string "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionStringAndArray.array "-b B1", "--duplicate=B1"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionStringAndBool < Clim
  # Default setting only.
  # For the spec case, please see the "it" block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [string & bool]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      #
      # spec case:
      #
      #   string "-a A1", "--duplicate=A1"
      #   bool "-b", "--duplicate"
      #
      SpecMainCommandWithDuplicateLongOptionStringAndBool.string "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionStringAndBool.bool "-b", "--duplicate"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionArrayAndBool < Clim
  # Default setting only.
  # For the spec case, please see the "it"  block below.
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [array & bool]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      #
      # spec case:
      #
      #   array "-a A1", "--duplicate=A1"
      #   bool "-b", "--duplicate"
      #
      SpecMainCommandWithDuplicateLongOptionArrayAndBool.array "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionArrayAndBool.bool "-b", "--duplicate"
    end
  end
end

class SpecMainCommandWhenCallTheMainCommandTwice < Clim
  # For the spec case, please see the "it" block below.
end

describe "Call the main command twice." do
  it "raises an Exception when Call the main command twice." do
    expect_raises(Exception, "Main command is already defined.") do
      #
      # spec case:
      #
      #  class SpecClass
      #    main_command
      #    desc "Main command with desc."
      #    usage "main_command with usage [options] [arguments]"
      #    run do |opts, args|
      #    end
      #
      #    main_command  # A second call.
      #  end
      #
      SpecMainCommandWhenCallTheMainCommandTwice.main_command
      SpecMainCommandWhenCallTheMainCommandTwice.desc "Main command with desc."
      SpecMainCommandWhenCallTheMainCommandTwice.usage "main_command with usage [options] [arguments]"
      SpecMainCommandWhenCallTheMainCommandTwice.run do |opts, args|
      end
      SpecMainCommandWhenCallTheMainCommandTwice.main_command # A second call.
    end
  end
end

class SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock < Clim
  # For the spec case, please see the "it" block below.
end

describe "Call the main command twice." do
  it "raises an Exception when Call the main command twice." do
    expect_raises(Exception, "Main command is already defined.") do
      #
      # spec case:
      #
      #  class SpecClass
      #    main_command
      #    desc "Main command with desc."
      #    usage "main_command with usage [options] [arguments]"
      #    run do |opts, args|
      #    end
      #
      #    sub do
      #      main_command  # A second call.
      #    end
      #  end
      #
      SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.main_command
      SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.desc "Main command with desc."
      SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.usage "main_command with usage [options] [arguments]"
      SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.run do |opts, args|
      end
      SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.sub do
        SpecMainCommandWhenCallTheMainCommandTwiceInSubBlock.main_command # A second call.
      end
    end
  end
end

class SpecMainCommandWhenMainCommandIsNotDefined < Clim
  # For the spec case, please see the "it" block below.
end

describe "Call the main command twice." do
  it "raises an Exception when call command method if main_command is not defined." do
    expect_raises(Exception, "Main command is not defined.") do
      #
      # spec case:
      #
      #  class SpecClass
      #    command "spec_case"
      #  end
      #
      SpecMainCommandWhenMainCommandIsNotDefined.command "spec_case"
    end
  end
end

class SpecMainCommandExecuteRunBlock < Clim
  main_command
  run do |opts, args|
    raise "Run block was executed."
  end
end

describe "Call the main command." do
  it "raises an Exception because execute run block." do
    expect_raises(Exception, "Run block was executed.") do
      SpecMainCommandExecuteRunBlock.start_main(%w(arg1))
    end
  end
end

class SpecMainCommandExecuteHelpBlock < Clim
  # For the spec case, please see the "it" block below.
end

describe "Call the main command." do
  it "raises an Exception because execute help block." do
    main_command = Command.new("main_command")
    main_command.help_proc = SpecMainCommandExecuteRunBlock::RunProc.new { raise "Help block was executed." }
    main_command.run_proc = SpecMainCommandExecuteRunBlock::RunProc.new { raise "Run block was executed." } # This should not be called.
    expect_raises(Exception, "Help block was executed.") do
      SpecMainCommandExecuteRunBlock.start_main(%w(--help), main_command)
    end
  end
end
