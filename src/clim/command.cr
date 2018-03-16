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

    macro desc(description)
      def desc : String
        {{ description.id.stringify }}
      end
    end

    def desc : String
      "Command Line Interface Tool."
    end

    macro usage(usage)
      def usage : String
        {{ usage.id.stringify }}
      end
    end

    def usage : String
      "#{name} [options] [arguments]"
    end

    macro alias_name(*names)
      {% if @type == CommandByClim_Main_command %}
        {% raise "'alias_name' is not supported on main command." %}
      {% end %}
      def alias_name : Array(String)
        {{ names }}.to_a
      end
    end

    def alias_name(*names) : Array(String)
      [] of String
    end

    macro version(version_str, short = nil)
      def version_str : String
        {{ version_str.id.stringify }}
      end

      def define_version(parser)
        {% if short == nil %}
          parser.on("--version", "Show version.") { @display_version_flag = true }
        {% else %}
          parser.on({{short.id.stringify}}, "--version", "Show version.") { @display_version_flag = true }
        {% end %}
      end
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

    def help
      Help.new(self).display
    end
  end
end
