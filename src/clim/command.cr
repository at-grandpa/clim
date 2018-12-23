require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    property name : String = ""
    property alias_name : Array(String) = [] of String
    property parser : OptionParser = OptionParser.new
    property arguments : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    include Clim::Command::Macros

    def desc : String
      "Command Line Interface Tool."
    end

    def usage : String
      "#{name} [options] [arguments]"
    end

    def alias_name(*names) : Array(String)
      [] of String
    end

    def version_str : String
      ""
    end

    abstract def run(io : IO)

    private def find_sub_cmds_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name || cmd.alias_name.includes?(name)
      end
    end

    def parse(argv)
      opts_validate!
      recursive_parse(argv)
    end

    private def opts_validate!
      raise ClimException.new "There are duplicate registered commands. [#{duplicate_names.join(",")}]" unless duplicate_names.empty?
    end

    private def duplicate_names
      names = @sub_commands.map(&.name)
      alias_names = @sub_commands.map(&.alias_name).flatten
      (names + alias_names).duplicate_value
    end

    def recursive_parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) if find_sub_cmds_by(argv.first).empty?
      find_sub_cmds_by(argv.first).first.recursive_parse(argv[1..-1])
    end

    abstract def initialize
  end
end
