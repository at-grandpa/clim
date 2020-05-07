require "../spec_helper"

class SpecCommand < Clim
  main do
    desc "main command."
    usage "main [sub_command] [arguments]"
    option "-g WORDS", "--greeting=WORDS", type: String, desc: "Words of greetings.", default: "Hello"
    option "-n NAME", type: Array(String), desc: "Target name.", default: ["Taro"], required: true
    run do |opts, args|
    end
    sub "abc" do
      desc "abc command."
      usage "main abc [tool] [arguments]"
      alias_name "def", "ghi"
      run do |opts, args|
      end
    end
    sub "abcdef" do
      desc "abcdef command."
      usage "main abcdef [options] [files]"
      alias_name "ghijkl", "mnopqr"
      run do |opts, args|
      end
    end
  end
end

class SpecCommandNoSubCommands < Clim
  main do
    desc "main command."
    usage "main [sub_command] [arguments]"
    option "-g WORDS", "--greeting=WORDS", type: String, desc: "Words of greetings.", default: "Hello"
    option "-n NAME", type: Array(String), desc: "Target name.", default: ["Taro"], required: true
    run do |opts, args|
    end
  end
end

describe Clim::Command do
  describe "#help_template" do
    it "returns help string with sub commands." do
      SpecCommand.command.help_template_str.should eq <<-OPTIONS

        main command.

        Usage:

          main [sub_command] [arguments]

        Options:

          -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]
          -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]
          --help                           Show this help.

        Sub Commands:

          abc, def, ghi            abc command.
          abcdef, ghijkl, mnopqr   abcdef command.


      OPTIONS
    end
    it "returns help string without sub commands." do
      SpecCommandNoSubCommands.command.help_template_str.should eq <<-OPTIONS

        main command.

        Usage:

          main [sub_command] [arguments]

        Options:

          -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]
          -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]
          --help                           Show this help.


      OPTIONS
    end
  end
  describe "#desc" do
    it "returns desc." do
      SpecCommand.command.desc.should eq "main command."
    end
  end
  describe "#usage" do
    it "returns usage." do
      SpecCommand.command.usage.should eq "main [sub_command] [arguments]"
    end
  end
  describe "#parser.to_s" do
    it "returns string of parser options." do
      SpecCommand.command.parser.option_parser.to_s.should eq <<-OPTIONS
          -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]
          -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]
          --help                           Show this help.
      OPTIONS
    end
  end
  describe "#max_sub_command_name_length" do
    it "returns max name length of sub commands." do
      SpecCommand.command.max_sub_command_name_length.should eq 22
    end
  end
  describe "#names" do
    it "returns name and alias_name of sub commands." do
      SpecCommand.command.sub_commands[0].names.should eq ["abc", "def", "ghi"]
      SpecCommand.command.sub_commands[1].names.should eq ["abcdef", "ghijkl", "mnopqr"]
    end
  end
  describe "#options_help_info" do
    it "returns options help info." do
      SpecCommand.command.options_help_info.should eq [
        {
          names:     ["-g WORDS", "--greeting=WORDS"],
          type:      String,
          desc:      "Words of greetings.",
          default:   "Hello",
          required:  false,
          help_line: "    -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]",
        },
        {
          names:     ["-n NAME"],
          type:      Array(String),
          desc:      "Target name.",
          default:   ["Taro"],
          required:  true,
          help_line: "    -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]",
        },
        {
          names:     ["--help"],
          type:      Bool,
          desc:      "Show this help.",
          default:   false,
          required:  false,
          help_line: "    --help                           Show this help.",
        },
      ]
    end
  end
  describe "#sub_commands_help_info" do
    it "returns sub commands help info." do
      SpecCommand.command.sub_commands_help_info.should eq [
        {
          names:     ["abc", "def", "ghi"],
          desc:      "abc command.",
          help_line: "    abc, def, ghi            abc command.",
        },
        {
          names:     ["abcdef", "ghijkl", "mnopqr"],
          desc:      "abcdef command.",
          help_line: "    abcdef, ghijkl, mnopqr   abcdef command.",
        },
      ]
    end
    it "returns sub commands info without sub commands." do
      SpecCommandNoSubCommands.command.sub_commands_help_info.should eq [] of Array(NamedTuple(names: Array(String), desc: String, help_line: String))
    end
  end
end
