require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    property name : String = ""
    property alias_name : Array(String) = [] of String
    property parser : OptionParser = OptionParser.new
    property arguments : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    macro desc(description)
      def desc : String
        {{ description }}
      end
    end

    def desc : String
      "Command Line Interface Tool."
    end

    macro usage(usage)
      def usage : String
        {{ usage }}
      end
    end

    def usage : String
      "#{name} [options] [arguments]"
    end

    macro alias_name(*names)
      {% raise "'alias_name' is not supported on main command." if @type == Command_Main_command_of_clim_library %}
      def alias_name : Array(String)
        {{ names }}.to_a
      end
    end

    def alias_name(*names) : Array(String)
      [] of String
    end

    macro version(version_str, short = nil)
      def version_str : String
        {{ version_str }}
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

    macro main
      main_command
    end

    macro main_command
      {% raise "Can not be declared 'main_command' or 'main' as sub command." if @type.superclass.id.stringify == "Clim::Command" %}
    end

    macro sub(name, &block)
      sub_command({{name}}) do
        {{ yield }}
      end
    end

    macro sub_command(name, &block)
      command({{name}}) do
        {{ yield }}
      end
    end

    macro run(&block)
      def run(io : IO)
        return RunProc.new { io.puts help_template_def }.call(@options, @arguments) if @options.help == true
        if @display_version_flag
          RunProc.new { io.puts version_str }.call(@options, @arguments)
        else
          RunProc.new {{ block.id }} .call(@options, @arguments)
        end
      end
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

    macro option_base(short, long, type, desc, default, required)
      {% raise "Empty option name." if short.empty? %}
      {% raise "Type [#{type}] is not supported on option." unless SUPPORT_TYPES.keys.includes?(type) %}

      {% base_option_name = long == nil ? short : long %}
      {% option_name = base_option_name.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").gsub(/-/, "_").id %}
      class OptionsForEachCommand
        class Option_{{option_name}} < Option
          define_option_macro({{option_name}}, {{type}}, {{default}}, {{required}})
        end

        {% default = false if type.id.stringify == "Bool" %}
        {% raise "You can not specify 'required: true' for Bool option." if type.id.stringify == "Bool" && required == true %}

        {% if default == nil %}
          {% default_value = SUPPORT_TYPES[type][:nilable] ? default : SUPPORT_TYPES[type][:default] %}
        {% else %}
          {% default_value = default %}
        {% end %}

        property {{ option_name }}_instance : Option_{{option_name}} = Option_{{option_name}}.new({{ short }}, {% unless long == nil %} {{ long }}, {% end %} {{ desc }}, {{ default_value }}, {{ required }})
        def {{ option_name }}
          {{ option_name }}_instance.@value
        end
      end
    end

    macro option(short, long, type = String, desc = "Option description.", default = nil, required = false)
      option_base({{short}}, {{long}}, {{type}}, {{desc}}, {{default}}, {{required}})
    end

    macro option(short, type = String, desc = "Option description.", default = nil, required = false)
      option_base({{short}}, nil, {{type}}, {{desc}}, {{default}}, {{required}})
    end

    macro command(name, &block)
      {% if @type.constants.map(&.id.stringify).includes?("Command_" + name.id.capitalize.stringify) %}
        {% raise "Command \"" + name.id.stringify + "\" is already defined." %}
      {% end %}

      class Command_{{ name.id.capitalize }} < Command
        property name : String = {{name.id.stringify}}

        class Options_{{ name.id.capitalize }} < Options
        end

        alias OptionsForEachCommand = Options_{{ name.id.capitalize }}

        private def parse_by_parser(argv)
          define_version(@parser)
          @parser.invalid_option do |opt_name|
            raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\""
          end
          @parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
          @parser.unknown_args { |unknown_args| @arguments = unknown_args }
          @parser.parse(argv.dup)
          required_validate! if @options.help == false
          @options.help_str = help_template_def
          self
        end

        def initialize
          @display_version_flag = false
          @parser = OptionParser.new
          @options = OptionsForEachCommand.new
          @options.setup_parser(@parser)
          \{% for command_class in @type.constants.select{|c| @type.constant(c).superclass.id.stringify == "Clim::Command"} %}
            @sub_commands << \{{ command_class.id }}.new
          \{% end %}
        end

        def options_info
          @options.info
        end

        private def required_validate!
          raise "Required options. \"#{@options.invalid_required_names.join("\", \"")}\"" unless @options.invalid_required_names.empty?
        end

        {{ yield }}

        option "--help", type: Bool, desc: "Show this help.", default: false

        alias RunProc = Proc(OptionsForEachCommand, Array(String), Nil)
        property options : OptionsForEachCommand = OptionsForEachCommand.new

        class OptionsForEachCommand
        end
      end
    end
  end
end
