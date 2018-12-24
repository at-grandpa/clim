require "./../../spec_helper"

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

describe Clim::Command::Help do
  describe "#display" do
    it "returns help string with sub commands." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.display.should eq <<-OPTIONS

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
      help = Clim::Command::Help.new(SpecCommandNoSubCommands.command)
      help.display.should eq <<-OPTIONS

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
      help = Clim::Command::Help.new(SpecCommand.command)
      help.desc.should eq "main command."
    end
  end
  describe "#usage" do
    it "returns usage." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.usage.should eq "main [sub_command] [arguments]"
    end
  end
  describe "#parser.to_s" do
    it "returns string of parser options." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.parser.option_parser.to_s.should eq <<-OPTIONS
          -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]
          -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]
          --help                           Show this help.
      OPTIONS
    end
  end
  describe "#sub_cmds_help" do
    it "returns sub commands help." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.sub_cmds_help.should eq <<-HELP_STRING
        Sub Commands:

          abc, def, ghi            abc command.
          abcdef, ghijkl, mnopqr   abcdef command.


      HELP_STRING
    end
  end
  describe "#sub_commands_help_lines" do
    it "returns sub commands help lines." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.sub_commands_help_lines.should eq [
        "    abc, def, ghi            abc command.",
        "    abcdef, ghijkl, mnopqr   abcdef command.",
      ]
    end
  end
  describe "#max_name_length" do
    it "returns max name length of sub commands." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.max_name_length.should eq 22
    end
  end
  describe "#names_of" do
    it "returns name and alias_name of sub commands." do
      help = Clim::Command::Help.new(SpecCommand.command)

      sub_command1 = SpecCommand.command.sub_commands[0]
      help.names_of(sub_command1).should eq ["abc", "def", "ghi"]

      sub_command2 = SpecCommand.command.sub_commands[1]
      help.names_of(sub_command2).should eq ["abcdef", "ghijkl", "mnopqr"]
    end
  end
  describe "#options" do
    it "returns options info." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.options.should eq [
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
  describe "#sub_commands" do
    it "returns sub commands info." do
      help = Clim::Command::Help.new(SpecCommand.command)
      help.sub_commands.should eq [
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
      help = Clim::Command::Help.new(SpecCommandNoSubCommands.command)
      help.sub_commands.should eq [] of Array(NamedTuple(names: Array(String), desc: String, help_line: String))
    end
  end
end
