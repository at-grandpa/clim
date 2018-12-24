require "option_parser"
require "./types"
require "./command/*"

class Clim
  abstract class Command
    include Clim::Command::Macros

    property name : String = ""
    property alias_name : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    {% begin %}
    {% support_types = Clim::Types::SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
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
    alias HelpTemplateType = Proc(String, String, HelpOptionsType, HelpSubCommandsType, String)

    DEAFULT_HELP_TEMPLATE = HelpTemplateType.new do |desc, usage, options, sub_commands|
      options_lines = options.map(&.[](:help_line))
      sub_commands_lines = sub_commands.map(&.[](:help_line))
      base_help_template = <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{options_lines.join("\n")}


      HELP_MESSAGE

      sub_commands_help_template = <<-HELP_MESSAGE
        Sub Commands:

      #{sub_commands_lines.join("\n")}


      HELP_MESSAGE
      sub_commands_lines.empty? ? base_help_template : base_help_template + sub_commands_help_template
    end

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

    def help_template_def
      help = Help.new(self)
      DEAFULT_HELP_TEMPLATE.call(help.desc, help.usage, help.options, help.sub_commands)
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

    private def parse_by_parser(argv)
      parser.parse(argv.dup)
      required_validate! unless parser.display_help?
      parser.options.help_str = help_template_def
      self
    end

    def options_info
      parser.options.info
    end

    private def required_validate!
      raise "Required options. \"#{parser.options.invalid_required_names.join("\", \"")}\"" unless parser.options.invalid_required_names.empty?
    end

    abstract def initialize
  end
end
