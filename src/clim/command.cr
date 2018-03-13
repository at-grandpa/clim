require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    include Macro

    property name : String = ""
    property parser : OptionParser = OptionParser.new
    property arguments : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    def desc : String
      ""
    end

    abstract def run

    def find_sub_cmds_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name
      end
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) if find_sub_cmds_by(argv.first).empty?
      find_sub_cmds_by(argv.first).first.parse(argv[1..-1])
    end

    private def parse_by_parser(argv)
      @parser.on("--help", "Show this help.") { @display_help_flag = true }
      @parser.invalid_option { |opt_name| raise Exception.new "Undefined option. \"#{opt_name}\"" }
      @parser.missing_option { |opt_name| raise Exception.new "Option that requires an argument. \"#{opt_name}\"" }
      @parser.unknown_args { |unknown_args| @arguments = unknown_args }
      @parser.parse(argv.dup)
      # opts.required_validate! unless display_help?
      # opts.help = help
      self
    end
  end

  # ===============================

  macro main_command(&block)
    Command.command "main_command_by_clim" do
      {{ yield }}
    end

    def self.start(argv)
      # argvの残りは、Commandが持っているといいかも
      # そうすると、runを呼ぶだけでいい
      CommandByClim_Main_command_by_clim.new.parse(argv).run
    end
  end
end
