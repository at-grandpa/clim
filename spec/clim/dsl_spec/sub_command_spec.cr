require "./../../spec_helper"

class SpecSubCommandOnly < Clim
  main_command
  run do |opts, args|
    raise "Main command is not target for spec."
    {opts: opts, args: args}
  end

  sub do
    command "sub_command"
    run do |opts, args|
      {opts: opts, args: args} # return values for spec.
    end
  end
end

describe "sub command only." do
  describe "returns main command help." do
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
        args_of_run_block = SpecSubCommandOnly.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Command Line Interface Tool.

            Usage:

              main_command [options] [arguments]

            Options:

              -h, --help                       Show this help.

            Sub Commands:

              sub_command   Command Line Interface Tool.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns sub command help." do
    [
      {
        argv: %w(sub_command -h),
      },
      {
        argv: %w(sub_command --help),
      },
      {
        argv: %w(sub_command -h ignore-arg),
      },
      {
        argv: %w(sub_command ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandOnly.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Command Line Interface Tool.

            Usage:

              sub_command [options] [arguments]

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
        argv:        %w(sub_command),
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(sub_command arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(sub_command arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(sub_command arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandOnly.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv to main command." do
    [
      {
        argv:              %w(sub_command -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command --missing-option),
        exception_message: "Undefined option. \"--missing-option\"",
      },
      {
        argv:              %w(sub_command -m arg1),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command arg1 -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command -m -d),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command -m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecSubCommandOnly.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecSubCommandWithDesc < Clim
  main_command
  desc "Main command description is not target for spec."
  run do |opts, args|
    raise "Main command is not target for spec."
    {opts: opts, args: args}
  end

  sub do
    command "sub_command"
    desc "Sub command with desc."
    run do |opts, args|
      {opts: opts, args: args} # return values for spec.
    end
  end
end

describe "sub command with desc." do
  describe "returns sub command help." do
    [
      {
        argv: %w(sub_command -h),
      },
      {
        argv: %w(sub_command --help),
      },
      {
        argv: %w(sub_command -h ignore-arg),
      },
      {
        argv: %w(sub_command ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandWithDesc.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Sub command with desc.

            Usage:

              sub_command [options] [arguments]

            Options:

              -h, --help                       Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
end

class SpecSubCommandWithUsage < Clim
  main_command
  desc "Main command description is not target for spec."
  usage "Main command usage is not target for spec."
  run do |opts, args|
    raise "Main command is not target for spec."
    {opts: opts, args: args}
  end

  sub do
    command "sub_command"
    desc "Sub command with desc."
    usage "sub_command with usage [options] [arguments]"
    run do |opts, args|
      {opts: opts, args: args} # return values for spec.
    end
  end
end

describe "sub command with usage." do
  describe "returns sub command help." do
    [
      {
        argv: %w(sub_command -h),
      },
      {
        argv: %w(sub_command --help),
      },
      {
        argv: %w(sub_command -h ignore-arg),
      },
      {
        argv: %w(sub_command ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandWithUsage.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Sub command with desc.

            Usage:

              sub_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
end

class SpecSubSubCommand < Clim
  main_command
  desc "Main command description is not target for spec."
  usage "Main command usage is not target for spec."
  run do |opts, args|
    raise "Main command is not target for spec."
    {opts: opts, args: args}
  end

  sub do
    command "sub_command"
    desc "Sub command with desc."
    usage "sub_command with usage [options] [arguments]"
    run do |opts, args|
      raise "Sub command is not target for spec."
      {opts: opts, args: args}
    end

    sub do
      command "sub_sub_command"
      desc "Sub sub command with desc."
      usage "sub_sub_command with usage [options] [arguments]"
      run do |opts, args|
        {opts: opts, args: args} # return values for spec.
      end
    end
  end
end

describe "sub sub command." do
  describe "returns sub sub command help." do
    [
      {
        argv: %w(sub_command sub_sub_command -h),
      },
      {
        argv: %w(sub_command sub_sub_command --help),
      },
      {
        argv: %w(sub_command sub_sub_command -h ignore-arg),
      },
      {
        argv: %w(sub_command sub_sub_command ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Sub sub command with desc.

            Usage:

              sub_sub_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns sub command help when there is no sub_sub_command next to sub_command." do
    [
      {
        argv: %w(sub_command -h sub_sub_command),
      },
      {
        argv: %w(sub_command --help sub_sub_command),
      },
      {
        argv: %w(sub_command -h ignore-arg sub_sub_command),
      },
      {
        argv: %w(sub_command ignore-arg sub_sub_command -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Sub command with desc.

            Usage:

              sub_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.

            Sub Commands:

              sub_sub_command   Sub sub command with desc.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(sub_command sub_sub_command),
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(sub_command sub_sub_command arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(sub_command sub_sub_command arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(sub_command sub_sub_command arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv to main command." do
    [
      {
        argv:              %w(sub_command sub_sub_command -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command sub_sub_command --missing-option),
        exception_message: "Undefined option. \"--missing-option\"",
      },
      {
        argv:              %w(sub_command sub_sub_command -m arg1),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command sub_sub_command arg1 -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command sub_sub_command -m -d),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(sub_command sub_sub_command -m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecSubSubCommand.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecSubCommandJumpOverSubSubCommand < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  run do |opts, args|
    raise "Main command is not target for spec."
    {opts: opts, args: args}
  end

  sub do
    command "sub_command"
    desc "Sub command with desc."
    usage "sub_command with usage [options] [arguments]"
    run do |opts, args|
      raise "Sub command is not target for spec."
      {opts: opts, args: args}
    end

    sub do
      command "sub_sub_command"
      desc "Sub sub command with desc."
      usage "sub_sub_command with usage [options] [arguments]"
      run do |opts, args|
        raise "Sub sub command is not target for spec."
        {opts: opts, args: args}
      end
    end

    command "jump_over_sub_sub_command"
    desc "Sub command jump over sub sub command."
    usage "jump_over_sub_sub_command with usage [options] [arguments]"
    run do |opts, args|
      {opts: opts, args: args} # return values for spec.
    end
  end
end

describe "sub command jump over sub sub command." do
  describe "returns jump over sub sub command help." do
    [
      {
        argv: %w(jump_over_sub_sub_command -h),
      },
      {
        argv: %w(jump_over_sub_sub_command --help),
      },
      {
        argv: %w(jump_over_sub_sub_command -h ignore-arg),
      },
      {
        argv: %w(jump_over_sub_sub_command ignore-arg -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandJumpOverSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Sub command jump over sub sub command.

            Usage:

              jump_over_sub_sub_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns main command help." do
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
        args_of_run_block = SpecSubCommandJumpOverSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.

            Sub Commands:

              sub_command                 Sub command with desc.
              jump_over_sub_sub_command   Sub command jump over sub sub command.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(jump_over_sub_sub_command),
        expect_opts: create_values,
        expect_args: [] of String,
      },
      {
        argv:        %w(jump_over_sub_sub_command arg1),
        expect_opts: create_values,
        expect_args: ["arg1"],
      },
      {
        argv:        %w(jump_over_sub_sub_command arg1 arg2),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2"],
      },
      {
        argv:        %w(jump_over_sub_sub_command arg1 arg2 arg3),
        expect_opts: create_values,
        expect_args: ["arg1", "arg2", "arg3"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecSubCommandJumpOverSubSubCommand.start_main(spec_case[:argv])
        args_of_run_block[:opts].string.should eq(spec_case[:expect_opts].string)
        args_of_run_block[:opts].bool.should eq(spec_case[:expect_opts].bool)
        args_of_run_block[:opts].array.should eq(spec_case[:expect_opts].array)
        args_of_run_block[:args].should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv to main command." do
    [
      {
        argv:              %w(jump_over_sub_sub_command -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(jump_over_sub_sub_command --missing-option),
        exception_message: "Undefined option. \"--missing-option\"",
      },
      {
        argv:              %w(jump_over_sub_sub_command -m arg1),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(jump_over_sub_sub_command arg1 -m),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(jump_over_sub_sub_command -m -d),
        exception_message: "Undefined option. \"-m\"",
      },
      {
        argv:              %w(jump_over_sub_sub_command -m -h),
        exception_message: "Undefined option. \"-m\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecSubCommandJumpOverSubSubCommand.start_main(spec_case[:argv])
        end
      end
    end
  end
end
