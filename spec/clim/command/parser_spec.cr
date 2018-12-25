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

class SpecCommandNoOptions < Clim
  main do
    desc "main command."
    usage "main [sub_command] [arguments]"
    run do |opts, args|
    end
  end
end

describe Clim::Command::Parser do
  describe "#options_help_info" do
    it "returns options help info." do
      SpecCommand.command.parser.options_help_info.should eq [
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
    it "returns options help info without sub commands." do
      SpecCommandNoOptions.command.parser.options_help_info.should eq [
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
end
