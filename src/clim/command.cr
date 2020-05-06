require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    include Macros

    getter name : String = ""
    getter desc : String = "Command Line Interface Tool."
    getter usage : String = "command [options] [arguments]"
    getter alias_name : Array(String) = [] of String
    getter version : String = ""
    getter sub_commands : Array(Command) = [] of Command

    abstract def initialize

    macro desc(description)
      getter desc : String = {{ description }}
    end

    macro usage(usage)
      getter usage : String = {{ usage }}
    end

    macro alias_name(*names)
      {% raise "'alias_name' is not supported on main command." if @type == Command_Main_command_of_clim_library %}
      getter alias_name : Array(String) = {{ names }}.to_a
    end

    macro version(version_str, short = nil)
      {% if short == nil %}
        option "--version", type: Bool, desc: "Show version.", default: false
      {% else %}
        option {{short.id.stringify}}, "--version", type: Bool, desc: "Show version.", default: false
      {% end %}

      getter version : String = {{ version_str }}
    end

    macro help(short = nil)
      {% raise "The 'help' directive requires the 'short' argument. (ex 'help short: \"-h\"'" if short == nil %}
      macro help_macro
        option {{short.id.stringify}}, "--help", type: Bool, desc: "Show this help.", default: false
      end
    end

    macro help_template(&block)
      {% raise "Can not be declared 'help_template' as sub command." unless @type == Command_Main_command_of_clim_library %}

      class Clim::Command
        {% begin %}
        {% support_types = Clim::Types::SUPPORTED_TYPES_OF_OPTION.map { |k, _| k } + [Nil] %}
        alias HelpOptionsType = Array(NamedTuple(
            names: Array(String),
            type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }},
            desc: String,
            default: {{ support_types.join(" | ").id }},
            required: Bool,
            help_line: String))
        {% end %}

        alias HelpSubCommandsType = Array(NamedTuple(
          names: Array(String),
          desc: String,
          help_line: String))

        def help_template
          Proc(String, String, HelpOptionsType, HelpSubCommandsType, String).new {{ block.stringify.id }} .call(
            desc,
            usage,
            options_help_info,
            sub_commands_help_info)
        end
      end
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
      parser.set_arguments_argv(argv.dup)
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
      ([name] + @alias_name)
    end
  end
end
