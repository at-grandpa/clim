require "./../../spec_helper"

class SpecMainCommandWithString < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithString.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"string" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"string" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithString.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithString.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringOnlyShortOption < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string only short option." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG                           Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"s" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"s" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"s" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"s" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"s" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"s" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"s" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"s" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Undefined option. \"--string\"",
      },
      {
        argv:              %w(--string string1),
        exception_message: "Undefined option. \"--string\"",
      },
      {
        argv:              %w(--string=string1),
        exception_message: "Undefined option. \"--string=string1\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Undefined option. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringOnlyShortOption.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringDesc < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description."
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string desc." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringDesc.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.


          HELP_MESSAGE
        )
      end
    end
  end
end

class SpecMainCommandWithStringDefault < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description.", default: "default value"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string default." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.  [default:default value]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringDefault.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringRequiredTrueAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description.", required: true, default: "default value"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string required true and default exists." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.  [default:default value]  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringRequiredTrueOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description.", required: true
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string required only." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(),
        exception_message: "Required options. \"-s ARG\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-s ARG\"",
      },
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringRequiredFalseAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description.", required: false, default: "default value"
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string required false and default exists." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.  [default:default value]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"string" => "default value"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithStringRequiredFalseOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  string "-s ARG", "--string=ARG", desc: "String option description.", required: false
  run do |opts, args|
    {opts: opts, args: args} # return values for spec.
  end
end

describe "main command with string required false only." do
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
      {
        argv: %w(-ignore-option -h),
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              -h, --help                       Show this help.
              -s ARG, --string=ARG             String option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"string" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"string" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string1 arg1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -s string1),
        expect_opts: create_values({"string" => "string1"}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-string), # Unintended case.
        expect_opts: create_values({"string" => "tring"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s=string1), # Unintended case.
        expect_opts: create_values({"string" => "=string1"}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithStringRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(--string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
      {
        argv:              %w(arg1 -s),
        exception_message: "Option that requires an argument. \"-s\"",
      },
      {
        argv:              %w(arg1 --string),
        exception_message: "Option that requires an argument. \"--string\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithStringRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end
