require "./../../spec_helper"

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
      {
        argv: %w(--help -ignore-option),
      },
      {
        argv: %w(-ignore-option --help),
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
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
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
      {
        argv: %w(--help -ignore-option),
      },
      {
        argv: %w(-ignore-option --help),
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
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
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
      {
        argv: %w(--help -ignore-option),
      },
      {
        argv: %w(-ignore-option --help),
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
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
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

describe "main command with empty short option." do
  it "raises an Exception when short option is empty. [string]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.string "", "--s1=S1"
    end
  end
  it "raises an Exception when short option is empty. [bool]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.bool "", "--b1=B1"
    end
  end
  it "raises an Exception when short option is empty. [array]" do
    expect_raises(Exception, "Empty short option.") do
      SpecMainCommandWithEmptyShortOption.array "", "--a1=A1"
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionStringAndArray < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [string & array]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-a\"") do
      SpecMainCommandWithDuplicateShortOptionStringAndArray.string "-a A1", "--a1=A1"
      SpecMainCommandWithDuplicateShortOptionStringAndArray.array "-a A2", "--a2=A2"
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionStringAndBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [string & bool]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-b\"") do
      SpecMainCommandWithDuplicateShortOptionStringAndBool.string "-b B1", "--b1=B1"
      SpecMainCommandWithDuplicateShortOptionStringAndBool.bool "-b", "--b2"
    end
  end
end

class SpecMainCommandWithDuplicateShortOptionArrayAndBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate short option [array & bool]." do
  it "raises an Exception when there is duplicate short option." do
    expect_raises(Exception, "Duplicate option. \"-c\"") do
      SpecMainCommandWithDuplicateShortOptionStringAndBool.array "-c C1", "--c1=C1"
      SpecMainCommandWithDuplicateShortOptionStringAndBool.bool "-c", "--c2"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionStringAndArray < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [string & array]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      SpecMainCommandWithDuplicateLongOptionStringAndArray.string "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionStringAndArray.array "-b B1", "--duplicate=B1"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionStringAndBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [string & bool]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      SpecMainCommandWithDuplicateLongOptionStringAndBool.string "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionStringAndBool.bool "-b", "--duplicate"
    end
  end
end

class SpecMainCommandWithDuplicateLongOptionArrayAndBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
  end
end

describe "main command with duplicate long option [array & bool]." do
  it "raises an Exception when there is duplicate long option." do
    expect_raises(Exception, "Duplicate option. \"--duplicate\"") do
      SpecMainCommandWithDuplicateLongOptionArrayAndBool.array "-a A1", "--duplicate=A1"
      SpecMainCommandWithDuplicateLongOptionArrayAndBool.bool "-b", "--duplicate"
    end
  end
end
