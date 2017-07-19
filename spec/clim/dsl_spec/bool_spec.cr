require "./../../spec_helper"

class SpecMainCommandWithBool < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool"
  run do |opts, args|
  end
end

describe "main command with bool." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBool.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b, --bool                       Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBool.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBool.run_proc_arguments(spec_case[:argv])
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
  end
end

describe "main command with bool only short option." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b                               Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"b" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"b" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"b" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"b" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"b" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolOnlyShortOption.run_proc_arguments(spec_case[:argv])
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
  end
end

describe "main command with bool arguments." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArguments.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG, --bool=ARG               Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArguments.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolArguments.run_proc_arguments(spec_case[:argv])
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
  end
end

describe "main command with bool." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG                           Option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"b" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"b" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values({"b" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"b" => false}),
        expect_args: [] of String,
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsOnlyShortOption.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolArgumentsOnlyShortOption.run_proc_arguments(spec_case[:argv])
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
  end
end

describe "main command with bool desc." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolDesc.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b, --bool                       Bool option description.


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
  end
end

describe "main command with bool default." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
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
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolDefault.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolDefault.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolRequiredTrueAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", required: true, default: false
  run do |opts, args|
  end
end

describe "main command with bool required true and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b, --bool                       Bool option description.  [default:false]  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
end

class SpecMainCommandWithBoolArgumentsRequiredTrueAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG", "--bool=ARG", desc: "Bool option description.", required: true, default: false
  run do |opts, args|
  end
end

describe "main command with bool arguments required true and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG, --bool=ARG               Bool option description.  [default:false]  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolArgumentsRequiredTrueAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolRequiredTrueOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", required: true
  run do |opts, args|
  end
end

describe "main command with bool required true only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b, --bool                       Bool option description.  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
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
        exception_message: "Required options. \"-b\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-b\"",
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        expect_raises(Exception, spec_case[:exception_message]) do
          SpecMainCommandWithBoolRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolArgumentsRequiredTrueOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG", "--bool=ARG", desc: "Bool option description.", required: true
  run do |opts, args|
  end
end

describe "main command with bool arguments required true only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG, --bool=ARG               Bool option description.  [required]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(-b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
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
        exception_message: "Required options. \"-b ARG\"",
      },
      {
        argv:              %w(arg1),
        exception_message: "Required options. \"-b ARG\"",
      },
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
          SpecMainCommandWithBoolArgumentsRequiredTrueOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolRequiredFalseAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", required: false, default: false
  run do |opts, args|
  end
end

describe "main command with bool required false and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
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
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    # no spec.
  end
end

class SpecMainCommandWithBoolArgumentsRequiredFalseAndDefaultExists < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG", "--bool=ARG", desc: "Bool option description.", required: false, default: false
  run do |opts, args|
  end
end

describe "main command with bool arguments required false and default exists." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG, --bool=ARG               Bool option description.  [default:false]


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolArgumentsRequiredFalseAndDefaultExists.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end

class SpecMainCommandWithBoolRequiredFalseOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b", "--bool", desc: "Bool option description.", required: false
  run do |opts, args|
  end
end

describe "main command with bool required false only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b, --bool                       Bool option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
      end
    end
  end
  describe "raises Exception when passing invalid argv." do
    # no spec.
  end
end

class SpecMainCommandWithBoolArgumentsRequiredFalseOnly < Clim
  main_command
  desc "Main command with desc."
  usage "main_command with usage [options] [arguments]"
  bool "-b ARG", "--bool=ARG", desc: "Bool option description.", required: false
  run do |opts, args|
  end
end

describe "main command with bool arguments required false only." do
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
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts["help"].should eq(
          <<-HELP_MESSAGE

            Main command with desc.

            Usage:

              main_command with usage [options] [arguments]

            Options:

              --help                           Show this help.
              -b ARG, --bool=ARG               Bool option description.


          HELP_MESSAGE
        )
      end
    end
  end
  describe "returns opts and args when passing argv." do
    [
      {
        argv:        %w(),
        expect_opts: create_values({"bool" => nil}),
        expect_args: [] of String,
      },
      {
        argv:        %w(arg1),
        expect_opts: create_values({"bool" => nil}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(-b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 -b false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool true arg1),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool true),
        expect_opts: create_values({"bool" => true}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(--bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--bool false arg1),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
      {
        argv:        %w(arg1 --bool false),
        expect_opts: create_values({"bool" => false}),
        expect_args: ["arg1"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        run_proc_opts, run_proc_args = SpecMainCommandWithBoolArgumentsRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        run_proc_opts.delete("help")
        run_proc_opts.should eq(spec_case[:expect_opts])
        run_proc_args.should eq(spec_case[:expect_args])
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
          SpecMainCommandWithBoolArgumentsRequiredFalseOnly.run_proc_arguments(spec_case[:argv])
        end
      end
    end
  end
end
