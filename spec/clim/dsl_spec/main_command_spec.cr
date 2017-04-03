require "./../../spec_helper"

class SpecMainCommandOnly < Clim
  main_command
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command only." do
  describe "returns help." do
    [
      {
        argv: %w(-h),
      },
      {
        argv: %w(--help),
      },
      {
        argv: %w(-h ignore-arg),
      },
      {
        argv: %w(ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandOnly.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Command Line Interface Tool.

            Usage:

              main_command [options] [arguments]

            Options:

              -h, --help                       Show this help.


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
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"] of String,
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandOnly.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
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
      {
        argv:              %w(-m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandOnly.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithDesc < Clim
  main_command
  desc "Main command with desc."
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with desc." do
  describe "returns help." do
    [
      {
        argv: %w(-h),
      },
      {
        argv: %w(--help),
      },
      {
        argv: %w(-h ignore-arg),
      },
      {
        argv: %w(ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithDesc.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command [options] [arguments]

            Options:

              -h, --help                       Show this help.


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
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"] of String,
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithDesc.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
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
      {
        argv:              %w(-m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithDesc.start_main(spec_case[:argv])
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
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with usage." do
  describe "returns help." do
    [
      {
        argv: %w(-h),
      },
      {
        argv: %w(--help),
      },
      {
        argv: %w(-h ignore-arg),
      },
      {
        argv: %w(ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithUsage.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.


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
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"] of String,
      },
      {
        argv:        %w(arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithUsage.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
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
      {
        argv:              %w(-m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithUsage.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandRaisesAnExceptionInRunBlock < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
    raise "Raises an Exception in run block."
    {opts: opts, args: args}
  end
end

describe "main command raises an Exception in run block." do
  describe "raises an Exception when passing invalid argv." do
    [
      {
        argv:              %w(arg1),
        exception_message: "Raises an Exception in run block.",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandRaisesAnExceptionInRunBlock.start_main(spec_case[:argv])
        end
      end
    end
  end
end
