require "./../spec_helper"

def create_values(
                  string = {} of String => String,
                  bool = {} of String => Bool,
                  array = {} of String => Array(String))
  values = Options::Values.new
  values.string = string
  values.bool = bool
  values.array = array
  values
end

class SpecMainCommand < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  string "-r STR", "--required-opt=STR", default: "default", desc: "required option description.", required: true
  string "-s STR", "--string=STR", default: "default", desc: "string option description."
  bool "-b", "--bool", default: false, desc: "bool option description."
  array "-a VALUE", "--array=VALUE", default: ["a", "b"], desc: "array option description."
  run do |opts, args|
  end
end

describe "main command" do
  it "returns description." do
    cmd = SpecMainCommand.main
    cmd.desc.should eq("main_command description.")
  end
  it "returns usage." do
    cmd = SpecMainCommand.main
    cmd.usage.should eq("main_command [sub command] [options]")
  end
  it "returns help." do
    cmd = SpecMainCommand.main
    cmd.help.should eq(
      <<-HELP_MESSAGE

        main_command description.

        Usage:

          main_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -r STR, --required-opt=STR       required option description.  [default:default]  [required]
          -s STR, --string=STR             string option description.  [default:default]
          -b, --bool                       bool option description.  [default:false]
          -a VALUE, --array=VALUE          array option description.  [default:["a", "b"]]


      HELP_MESSAGE
    )
  end
  describe "#parse" do
    describe "returns opts and args when passing argv to #parse." do
      [
        {
          argv:        %w(-r required_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "default",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-rrequired_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "default",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(--required-opt required_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "default",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(--required-opt=required_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "default",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "default",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-s string_arg -r required_arg),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => false,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg -b),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg --bool),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg -b -a foo),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b", "foo"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg -b -a foo -a bar -a baz),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b", "foo", "bar", "baz"],
            },
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(-r required_arg -s string_arg -b -a foo -a bar -a baz arg1 arg2 arg3),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b", "foo", "bar", "baz"],
            },
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
        {
          argv:        %w(-a foo arg1 -r required_arg -a bar arg2 -s string_arg -b -a baz arg3),
          expect_opts: create_values(
            {
              "required-opt" => "required_arg",
              "string"       => "string_arg",
            },
            {
              "bool" => true,
            },
            {
              "array" => ["a", "b", "foo", "bar", "baz"],
            },
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          cmd = SpecMainCommand.main.parse(spec_case[:argv])
          cmd.opts.values.help = cmd.help
          cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
          cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
          cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
          cmd.args.should eq(spec_case[:expect_args])
        end
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(),
          exception_message: "Required options. \"-r STR\"",
        },
        {
          argv:              %w(-s string_arg),
          exception_message: "Required options. \"-r STR\"",
        },
        {
          argv:              %w(-r),
          exception_message: "Option that requires an argument. \"-r\"",
        },
        {
          argv:              %w(-r required_arg -s),
          exception_message: "Option that requires an argument. \"-s\"",
        },
        {
          argv:              %w(-r required_arg -a),
          exception_message: "Option that requires an argument. \"-a\"",
        },
        {
          argv:              %w(--missing-option),
          exception_message: "Undefined option. \"--missing-option\"",
        },
        {
          argv:              %w(-r required_arg --missing-option),
          exception_message: "Undefined option. \"--missing-option\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecMainCommand.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end

class SpecParseStringOption < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  string "-s STR", "--string=STR", default: "default", desc: "string option."
  run do |opts, args|
  end
end

describe "parse string option." do
  describe "returns opts and args when passing argv to #parse." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(string: {"string" => "default"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string_arg),
        expect_opts: create_values(string: {"string" => "string_arg"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sstring_arg),
        expect_opts: create_values(string: {"string" => "string_arg"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string string_arg),
        expect_opts: create_values(string: {"string" => "string_arg"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--string=string_arg),
        expect_opts: create_values(string: {"string" => "string_arg"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s first -s second -s third),
        expect_opts: create_values(string: {"string" => "third"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s string_arg arg),
        expect_opts: create_values(string: {"string" => "string_arg"}),
        expect_args: ["arg"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        cmd = SpecParseStringOption.main.parse(spec_case[:argv])
        cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
        cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
        cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
        cmd.args.should eq(spec_case[:expect_args])
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(-s),
          exception_message: "Option that requires an argument. \"-s\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecParseStringOption.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end

class SpecParseStringOptionOnlyShortName < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  string "-s STR", default: "default", desc: "string option."
  run do |opts, args|
  end
end

describe "parse string" do
  describe "returns opts and args when passing argv to #parse." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(string: {"s" => "default"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s foo),
        expect_opts: create_values(string: {"s" => "foo"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-sfoo),
        expect_opts: create_values(string: {"s" => "foo"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s foo -s bar -s baz),
        expect_opts: create_values(string: {"s" => "baz"}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-s foo arg),
        expect_opts: create_values(string: {"s" => "foo"}),
        expect_args: ["arg"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        cmd = SpecParseStringOptionOnlyShortName.main.parse(spec_case[:argv])
        cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
        cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
        cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
        cmd.args.should eq(spec_case[:expect_args])
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(-s),
          exception_message: "Option that requires an argument. \"-s\"",
        },
        {
          argv:              %w(--string string_arg),
          exception_message: "Undefined option. \"--string\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecParseStringOptionOnlyShortName.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end

class SpecParseBoolOption < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  bool "-b", "--bool", default: false, desc: "bool option."
  run do |opts, args|
  end
end

describe "parse bool option." do
  describe "returns opts and args when passing argv to #parse." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(bool: {"bool" => false}),
        expect_args: [] of String,
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
        argv:        %w(-b -b),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-b arg),
        expect_opts: create_values(bool: {"bool" => true}),
        expect_args: ["arg"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        cmd = SpecParseBoolOption.main.parse(spec_case[:argv])
        cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
        cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
        cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
        cmd.args.should eq(spec_case[:expect_args])
      end
    end
  end
end

class SpecParseArrayOption < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  array "-a VALUE", "--array=VALUE", default: ["a", "b"], desc: "array option."
  run do |opts, args|
  end
end

describe "parse array option." do
  describe "returns opts and args when passing argv to #parse." do
    [
      {
        argv:        %w(),
        expect_opts: create_values(array: {"array" => ["a", "b"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a foo),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-afoo),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array foo),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(--array=foo),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a foo -a bar -a baz),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo", "bar", "baz"]}),
        expect_args: [] of String,
      },
      {
        argv:        %w(-a foo arg),
        expect_opts: create_values(array: {"array" => ["a", "b", "foo"]}),
        expect_args: ["arg"],
      },
    ].each do |spec_case|
      it "#{spec_case[:argv].join(" ")}" do
        cmd = SpecParseArrayOption.main.parse(spec_case[:argv])
        cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
        cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
        cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
        cmd.args.should eq(spec_case[:expect_args])
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(-a),
          exception_message: "Option that requires an argument. \"-a\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecParseArrayOption.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end

class SpecSubCommand < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  string "-w STR", "--w-dummy=STR", default: "default", desc: "dummy option description.", required: true
  string "-x STR", "--x-dummy=STR", default: "default", desc: "dummy option description."
  bool "-y", "--y-dummy", default: false, desc: "dummy option description."
  array "-z VALUE", "--z-dummy=VALUE", default: ["a", "b"], desc: "dummy option description."
  run do |opts, args|
  end

  sub do
    command "sub_command"
    desc "sub_command description."
    usage "sub_command [sub command] [options]"
    string "-s STR", "--string=STR", default: "default", desc: "string option description."
    bool "-b", "--bool", default: false, desc: "bool option description."
    array "-a VALUE", "--array=VALUE", default: ["a", "b"], desc: "array option description."
    run do |opts, args|
    end

    command "sub_command_long_name"
    desc "sub_command_long_name description."
    usage "sub_command_long_name [sub command] [options]"
    string "-x STR", "--x-dummy=STR", default: "default", desc: "dummy option description."
    bool "-y", "--y-dummy", default: false, desc: "dummy option description."
    array "-z VALUE", "--z-dummy=VALUE", default: ["a", "b"], desc: "dummy option description."
    run do |opts, args|
    end
  end
end

describe "sub command" do
  it "returns description." do
    cmd = SpecSubCommand.main.parse(%w(sub_command))
    cmd.desc.should eq("sub_command description.")
  end
  it "returns usage." do
    cmd = SpecSubCommand.main.parse(%w(sub_command))
    cmd.usage.should eq("sub_command [sub command] [options]")
  end
  it "returns main command help." do
    cmd = SpecSubCommand.main
    cmd.help.should eq(
      <<-HELP_MESSAGE

        main_command description.

        Usage:

          main_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -w STR, --w-dummy=STR            dummy option description.  [default:default]  [required]
          -x STR, --x-dummy=STR            dummy option description.  [default:default]
          -y, --y-dummy                    dummy option description.  [default:false]
          -z VALUE, --z-dummy=VALUE        dummy option description.  [default:["a", "b"]]

        Sub Commands:

          sub_command             sub_command description.
          sub_command_long_name   sub_command_long_name description.


      HELP_MESSAGE
    )
  end
  it "returns sub command help." do
    cmd = SpecSubCommand.main.parse(%w(sub_command))
    cmd.help.should eq(
      <<-HELP_MESSAGE

        sub_command description.

        Usage:

          sub_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -s STR, --string=STR             string option description.  [default:default]
          -b, --bool                       bool option description.  [default:false]
          -a VALUE, --array=VALUE          array option description.  [default:["a", "b"]]


      HELP_MESSAGE
    )
  end
  describe "#parse" do
    describe "returns opts and args when passing argv to #parse." do
      [
        {
          argv:        %w(sub_command -s string_arg),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => false},
            {"array" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command -s string_arg -b),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command -s string_arg -b -a foo -a bar -a baz),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command -s string_arg -b -a foo -a bar -a baz arg1 arg2 arg3),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
        {
          argv:        %w(sub_command -a foo arg1 -a bar arg2 -s string_arg -b -a baz arg3),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          cmd = SpecSubCommand.main.parse(spec_case[:argv])
          cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
          cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
          cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
          cmd.args.should eq(spec_case[:expect_args])
        end
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(sub_command -s),
          exception_message: "Option that requires an argument. \"-s\"",
        },
        {
          argv:              %w(sub_command -a),
          exception_message: "Option that requires an argument. \"-a\"",
        },
        {
          argv:              %w(sub_command --missing-option),
          exception_message: "Undefined option. \"--missing-option\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecSubCommand.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end

class SpecSubSubCommand < Clim
  main_command
  desc "main_command description."
  usage "main_command [sub command] [options]"
  string "-w STR", "--w-dummy=STR", default: "default", desc: "dummy option description.", required: true
  string "-x STR", "--x-dummy=STR", default: "default", desc: "dummy option description."
  bool "-y", "--y-dummy", default: false, desc: "dummy option description."
  array "-z VALUE", "--z-dummy=VALUE", default: ["a", "b"], desc: "dummy option description."
  run do |opts, args|
  end

  sub do
    command "sub_command"
    desc "sub_command description."
    usage "sub_command [sub command] [options]"
    string "-x STR", "--x-dummy=STR", default: "default", desc: "dummy option description."
    bool "-y", "--y-dummy", default: false, desc: "dummy option description."
    array "-z VALUE", "--z-dummy=VALUE", default: ["a", "b"], desc: "dummy option description."
    run do |opts, args|
    end

    sub do
      command "sub_sub_command"
      desc "sub_sub_command description."
      usage "sub_sub_command [sub command] [options]"
      string "-s STR", "--string=STR", default: "default", desc: "string option description."
      bool "-b", "--bool", default: false, desc: "bool option description."
      array "-a VALUE", "--array=VALUE", default: ["a", "b"], desc: "array option description."
      run do |opts, args|
      end
    end

    command "sub_command_long_name"
    desc "sub_command_long_name description."
    usage "sub_command_long_name [sub command] [options]"
    string "-x STR", "--x-dummy=STR", default: "default", desc: "dummy option description."
    bool "-y", "--y-dummy", default: false, desc: "dummy option description."
    array "-z VALUE", "--z-dummy=VALUE", default: ["a", "b"], desc: "dummy option description."
    run do |opts, args|
    end
  end
end

describe "sub sub command" do
  it "returns description." do
    cmd = SpecSubSubCommand.main.parse(%w(sub_command sub_sub_command))
    cmd.desc.should eq("sub_sub_command description.")
  end
  it "returns usage." do
    cmd = SpecSubSubCommand.main.parse(%w(sub_command sub_sub_command))
    cmd.usage.should eq("sub_sub_command [sub command] [options]")
  end
  it "returns main command help." do
    cmd = SpecSubSubCommand.main
    cmd.help.should eq(
      <<-HELP_MESSAGE

        main_command description.

        Usage:

          main_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -w STR, --w-dummy=STR            dummy option description.  [default:default]  [required]
          -x STR, --x-dummy=STR            dummy option description.  [default:default]
          -y, --y-dummy                    dummy option description.  [default:false]
          -z VALUE, --z-dummy=VALUE        dummy option description.  [default:["a", "b"]]

        Sub Commands:

          sub_command             sub_command description.
          sub_command_long_name   sub_command_long_name description.


      HELP_MESSAGE
    )
  end
  it "returns sub command help." do
    cmd = SpecSubSubCommand.main.parse(%w(sub_command))
    cmd.help.should eq(
      <<-HELP_MESSAGE

        sub_command description.

        Usage:

          sub_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -x STR, --x-dummy=STR            dummy option description.  [default:default]
          -y, --y-dummy                    dummy option description.  [default:false]
          -z VALUE, --z-dummy=VALUE        dummy option description.  [default:["a", "b"]]

        Sub Commands:

          sub_sub_command   sub_sub_command description.


      HELP_MESSAGE
    )
  end
  it "returns sub command long name help." do
    cmd = SpecSubSubCommand.main.parse(%w(sub_command_long_name))
    cmd.help.should eq(
      <<-HELP_MESSAGE

        sub_command_long_name description.

        Usage:

          sub_command_long_name [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -x STR, --x-dummy=STR            dummy option description.  [default:default]
          -y, --y-dummy                    dummy option description.  [default:false]
          -z VALUE, --z-dummy=VALUE        dummy option description.  [default:["a", "b"]]


      HELP_MESSAGE
    )
  end
  it "returns sub sub command help." do
    cmd = SpecSubSubCommand.main.parse(%w(sub_command sub_sub_command))
    cmd.help.should eq(
      <<-HELP_MESSAGE

        sub_sub_command description.

        Usage:

          sub_sub_command [sub command] [options]

        Options:

          -h, --help                       Show this help.
          -s STR, --string=STR             string option description.  [default:default]
          -b, --bool                       bool option description.  [default:false]
          -a VALUE, --array=VALUE          array option description.  [default:["a", "b"]]


      HELP_MESSAGE
    )
  end
  describe "sub_command_long_name#parse" do
    describe "returns opts and args when passing argv to #parse." do
      [
        {
          argv:        %w(sub_command_long_name -x string_arg),
          expect_opts: create_values(
            {"x-dummy" => "string_arg"},
            {"y-dummy" => false},
            {"z-dummy" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command_long_name -x string_arg -y),
          expect_opts: create_values(
            {"x-dummy" => "string_arg"},
            {"y-dummy" => true},
            {"z-dummy" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command_long_name -x string_arg -y -z foo -z bar -z baz),
          expect_opts: create_values(
            {"x-dummy" => "string_arg"},
            {"y-dummy" => true},
            {"z-dummy" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command_long_name -x string_arg -y -z foo -z bar -z baz arg1 arg2 arg3),
          expect_opts: create_values(
            {"x-dummy" => "string_arg"},
            {"y-dummy" => true},
            {"z-dummy" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
        {
          argv:        %w(sub_command_long_name -z foo arg1 -z bar arg2 -x string_arg -y -z baz arg3),
          expect_opts: create_values(
            {"x-dummy" => "string_arg"},
            {"y-dummy" => true},
            {"z-dummy" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          cmd = SpecSubSubCommand.main.parse(spec_case[:argv])
          cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
          cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
          cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
          cmd.args.should eq(spec_case[:expect_args])
        end
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(sub_command_long_name -x),
          exception_message: "Option that requires an argument. \"-x\"",
        },
        {
          argv:              %w(sub_command_long_name -z),
          exception_message: "Option that requires an argument. \"-z\"",
        },
        {
          argv:              %w(sub_command_long_name --missing-option),
          exception_message: "Undefined option. \"--missing-option\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecSubSubCommand.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
  describe "sub_sub_command#parse" do
    describe "returns opts and args when passing argv to #parse." do
      [
        {
          argv:        %w(sub_command sub_sub_command -s string_arg),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => false},
            {"array" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command sub_sub_command -s string_arg -b),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command sub_sub_command -s string_arg -b -a foo -a bar -a baz),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: [] of String,
        },
        {
          argv:        %w(sub_command sub_sub_command -s string_arg -b -a foo -a bar -a baz arg1 arg2 arg3),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
        {
          argv:        %w(sub_command sub_sub_command -a foo arg1 -a bar arg2 -s string_arg -b -a baz arg3),
          expect_opts: create_values(
            {"string" => "string_arg"},
            {"bool" => true},
            {"array" => ["a", "b", "foo", "bar", "baz"]},
          ),
          expect_args: ["arg1", "arg2", "arg3"],
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          cmd = SpecSubSubCommand.main.parse(spec_case[:argv])
          cmd.opts.values.string.should eq(spec_case[:expect_opts].string)
          cmd.opts.values.bool.should eq(spec_case[:expect_opts].bool)
          cmd.opts.values.array.should eq(spec_case[:expect_opts].array)
          cmd.args.should eq(spec_case[:expect_args])
        end
      end
    end
    describe "raises Exception when passing invalid argv to #parse." do
      [
        {
          argv:              %w(sub_command sub_sub_command -s),
          exception_message: "Option that requires an argument. \"-s\"",
        },
        {
          argv:              %w(sub_command sub_sub_command -a),
          exception_message: "Option that requires an argument. \"-a\"",
        },
        {
          argv:              %w(sub_command sub_sub_command --missing-option),
          exception_message: "Undefined option. \"--missing-option\"",
        },
      ].each do |spec_case|
        it "#{spec_case[:argv].join(" ")}" do
          expect_raises(Exception, spec_case[:exception_message]) do
            SpecSubSubCommand.main.parse(spec_case[:argv])
          end
        end
      end
    end
  end
end
