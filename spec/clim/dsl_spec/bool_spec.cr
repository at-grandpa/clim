require "./../../spec_helper"

class SpecMainCommandWithBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool." do
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
        args_of_run_block = SpecMainCommandWithBool.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b, --bool                       Option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(-b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBool.start_main(spec_case[:argv])
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
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBool.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolOnlyShortOption < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool only short option." do
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
        args_of_run_block = SpecMainCommandWithBoolOnlyShortOption.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b                               Option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"b" => false} of String => Bool),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values(bool: {"b" => false}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(-b),
        expect_opts: create_values(bool: {"b" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values(bool: {"b" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values(bool: {"b" => true}),
        expect_args: ["arg1"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBoolOnlyShortOption.start_main(spec_case[:argv])
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
        argv:              %w(--bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool=ARG),
        exception_message: "Undefined option. \"--bool=ARG\"",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolOnlyShortOption.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolArguments < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG", "--bool=ARG"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool arguments." do
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
        args_of_run_block = SpecMainCommandWithBoolArguments.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b ARG, --bool=ARG               Option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"bool" => false} of String => Bool),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBoolArguments.start_main(spec_case[:argv])
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Option that requires an argument. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolArguments.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolArgumentsOnlyShortOption < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool." do
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
        args_of_run_block = SpecMainCommandWithBoolArgumentsOnlyShortOption.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b ARG                           Option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"b" => false} of String => Bool),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values(bool: {"b" => false}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values(bool: {"b" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values(bool: {"b" => false}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBoolArgumentsOnlyShortOption.start_main(spec_case[:argv])
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
        argv:              %w(-b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(--bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool true),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(--bool false),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(arg1 -b),
        exception_message: "Option that requires an argument. \"-b\"",
      },
      {
        argv:              %w(arg1 --bool),
        exception_message: "Undefined option. \"--bool\"",
      },
      {
        argv:              %w(-b arg1),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [arg1]",
      },
      {
        argv:              %w(--bool=arg1),
        exception_message: "Undefined option. \"--bool=arg1\"",
      },
      {
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Bool arguments accept only \"true\" or \"false\". Input: [ool]",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolArgumentsOnlyShortOption.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolDesc < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description."
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool desc." do
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
        args_of_run_block = SpecMainCommandWithBoolDesc.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b, --bool                       Bool option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
end

class SpecMainCommandWithBoolDefault < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", default: false
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool default." do
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
        args_of_run_block = SpecMainCommandWithBoolDefault.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b, --bool                       Bool option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(-b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBoolDefault.start_main(spec_case[:argv])
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
        argv:              %w(--b),
        exception_message: "Undefined option. \"--b\"",
      },
      {
        argv:              %w(-bool),
        exception_message: "Undefined option. \"-bool\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolDefault.start_main(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolRequired < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", default: false, required: true
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with bool required." do
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
        args_of_run_block = SpecMainCommandWithBoolRequired.start_main(spec_case[:argv])
        args_of_run_block[:opts].help.should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -b, --bool                       Bool option description.  [default:false]  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(-b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg1"] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        args_of_run_block = SpecMainCommandWithBoolRequired.start_main(spec_case[:argv])
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
        argv:              %w(),
        exception_message: "Required options. \"-b\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-b\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolRequired.start_main(spec_case[:argv])
        end
      end
    end
  end
end
