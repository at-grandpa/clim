require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    include Macros

    property name : String = ""
    property alias_name : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    abstract def initialize

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

    def help_template
      options_lines = options_help_info.map(&.[](:help_line))
      arguments_lines = arguments_help_info.map(&.[](:help_line))
      sub_commands_lines = sub_commands_help_info.map(&.[](:help_line))
      base_help_template = <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{options_lines.join("\n")}


      HELP_MESSAGE

      arguments_help_template = <<-HELP_MESSAGE
        Arguments:

      #{arguments_lines.join("\n")}


      HELP_MESSAGE

      sub_commands_help_template = <<-HELP_MESSAGE
        Sub Commands:

      #{sub_commands_lines.join("\n")}


      HELP_MESSAGE

      if sub_commands_lines.empty? && arguments_lines.empty?
        base_help_template
      elsif sub_commands_lines.empty? && !arguments_lines.empty?
        base_help_template + arguments_help_template
      elsif !sub_commands_lines.empty? && arguments_lines.empty?
        base_help_template + sub_commands_help_template
      else
        base_help_template + arguments_help_template + sub_commands_help_template
      end
    end

    abstract def run(io : IO)

    def parse(argv)
      raise ClimException.new "There are duplicate registered commands. [#{duplicate_names.join(",")}]" unless duplicate_names.empty?
      recursive_parse(argv)
    end

    private def duplicate_names
      names = @sub_commands.map(&.name)
      alias_names = @sub_commands.map(&.alias_name).flatten
      (names + alias_names).duplicate_value
    end

    def recursive_parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) if find_sub_commands_by(argv.first).empty?
      find_sub_commands_by(argv.first).first.recursive_parse(argv[1..-1])
    end

    private def parse_by_parser(argv)
      parser.parse(argv.dup)
      parser.set_arguments
      parser.required_validate!
      parser.set_help_string(help_template)
      self
    end

    private def find_sub_commands_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name || cmd.alias_name.includes?(name)
      end
    end

    def options_help_info
      parser.options_help_info
    end

    def arguments_help_info
      parser.arguments_help_info
    end

    def sub_commands_help_info
      sub_commands_info = @sub_commands.map do |cmd|
        {
          names:     cmd.names,
          desc:      cmd.desc,
          help_line: help_line_of(cmd),
        }
      end
    end

    def help_line_of(cmd)
      names_and_spaces = cmd.names.join(", ") +
                         "#{" " * (max_sub_command_name_length - cmd.names.join(", ").size)}"
      "    #{names_and_spaces}   #{cmd.desc}"
    end

    def max_sub_command_name_length
      @sub_commands.empty? ? 0 : @sub_commands.map(&.names.join(", ").size).max
    end

    def names
      ([name] + alias_name)
    end
  end
end
