require "./../../spec_helper"
require "./../dsl_spec"

class SpecMainCommandWithArray < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG"
  run do |opts, args|
  end
end

describe "main command with array." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArray.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"array" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"array" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        arun_proc_opts, run_proc_args = SpecMainCommandWithArray.run_proc_arguments(spec_case[:argv])
        arun_proc_opts.delete("help")
        arun_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArray.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayOnlyShortOption < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG"
  run do |opts, args|
  end
end

describe "main command with array only short option." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG                           Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"a" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"a" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"a" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"a" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"a" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"a" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"a" => ["rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"a" => ["=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Undefined option. \"--array\"",
      },
      {
        argv:              %w(--array attay1),
        exception_message: "Undefined option. \"--array\"",
      },
      {
        argv:              %w(--array=array1),
        exception_message: "Undefined option. \"--array=array1\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Undefined option. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayOnlyShortOption.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayDesc < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description."
  run do |opts, args|
  end
end

describe "main command with array desc." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayDesc.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.


          HELP_MESSAGE
        )
      end
    end
  end
end

class SpecMainCommandWithArrayDefault < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description.", default: ["default value"]
  run do |opts, args|
  end
end

describe "main command with array default." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.  [default:["default value"]]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayDefault.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayRequiredTrueAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description.", required: true, default: ["default value"]
  run do |opts, args|
  end
end

describe "main command with array required true and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.  [default:["default value"]]  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayRequiredTrueOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description.", required: true
  run do |opts, args|
  end
end

describe "main command with array required true only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
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
        exception_message: "Required options. \"-a ARG\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-a ARG\"",
      },
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayRequiredFalseAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description.", required: false, default: ["default value"]
  run do |opts, args|
  end
end

describe "main command with array required false and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.  [default:["default value"]]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"array" => ["default value"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["default value", "array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["default value", "=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithArrayRequiredFalseOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  array "-a ARG", "--array=ARG", desc: "Array option description.", required: false
  run do |opts, args|
  end
end

describe "main command with array required false only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -a ARG, --array=ARG              Array option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"array" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"array" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-aarray1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a array1 arg1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -a array1),
        expect_opts: create_values({"array" => ["array1"]}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-array), # Unintended case.
        expect_opts: create_values({"array" => ["rray"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a=array1), # Unintended case.
        expect_opts: create_values({"array" => ["=array1"]}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithArrayRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    [
      {
        argv:              %w(-a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(--array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
      {
        argv:              %w(arg1 -a),
        exception_message: "Option that requires an argument. \"-a\"",
      },
      {
        argv:              %w(arg1 --array),
        exception_message: "Option that requires an argument. \"--array\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithArrayRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end
