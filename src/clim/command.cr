require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    include Macro

    property name : String = ""
    property alias_name : Array(String) = [] of String
    property parser : OptionParser = OptionParser.new
    property arguments : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    def desc : String
      "Command Line Interface Tool."
    end

    def usage : String
      "#{name} [options] [arguments]"
    end

    def alias_name(*names) : Array(String)
      raise Exception.new("'alias_name' is not supported on main command.") if @name == "main_command_by_clim"
      [] of String
    end

    def version_str
      ""
    end

    def define_version(parser)
    end

    abstract def run(io : IO)

    def find_sub_cmds_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name || cmd.alias_name.includes?(name)
      end
    end

    def parse(argv)
      opts_validate!
      recursive_parse(argv)
    end

    private def opts_validate!
      raise Exception.new "There are duplicate registered commands. [#{duplicate_names.join(",")}]" unless duplicate_names.empty?
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

    def help
      @sub_commands.empty? ? base_help : base_help + sub_cmds_help
    end

    private def base_help
      <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{@parser}


      HELP_MESSAGE
    end

    def sub_cmds_help
      <<-HELP_MESSAGE
        Sub Commands:

      #{sub_cmds_help_lines.join("\n")}


      HELP_MESSAGE
    end

    def sub_cmds_help_lines
      @sub_commands.map do |cmd|
        name = name_and_alias_name(cmd) + "#{" " * (max_name_length - name_and_alias_name(cmd).size)}"
        "    #{name}   #{cmd.desc}"
      end
    end

    def max_name_length
      @sub_commands.empty? ? 0 : @sub_commands.map { |cmd| name_and_alias_name(cmd).size }.max
    end

    def name_and_alias_name(cmd)
      ([cmd.name] + cmd.alias_name).join(", ")
    end
  end
end
