require "option_parser"
require "./command/*"

class Clim
  abstract class Command
    getter name : String = ""
    getter desc : String = "Command Line Interface Tool."
    getter usage : String = "command [options] [arguments]"
    getter alias_name : Array(String) = [] of String
    getter version : String = ""

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

    def help_template_str : String
      options_lines = @options.help_info.map(&.[](:help_line))
      arguments_lines = @arguments.help_info.map(&.[](:help_line))
      sub_commands_lines = @sub_commands.help_info.map(&.[](:help_line))
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

    macro help_template(&block)
      {% raise "Can not be declared 'help_template' as sub command." unless @type == Command_Main_command_of_clim_library %}

      class Clim::Command
        {% begin %}
          {% support_types_of_option = Clim::Types::SUPPORTED_TYPES_OF_OPTION.map { |k, _| k } + [Nil] %}
          alias HelpOptionsType = Array(NamedTuple(
              names: Array(String),
              type: {{ support_types_of_option.map(&.stringify.+(".class")).join(" | ").id }},
              desc: String,
              default: {{ support_types_of_option.join(" | ").id }},
              required: Bool,
              help_line: String))

          {% support_types_of_argument = Clim::Types::SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          alias HelpArgumentsType = Array(NamedTuple(
              method_name: String,
              display_name: String,
              type: {{ support_types_of_argument.map(&.stringify.+(".class")).join(" | ").id }},
              desc: String,
              default: {{ support_types_of_argument.join(" | ").id }},
              required: Bool,
              sequence_number: Int32,
              help_line: String))
        {% end %}

        alias HelpSubCommandsType = Array(NamedTuple(
          names: Array(String),
          desc: String,
          help_line: String))

        def help_template_str : String
          Proc(String, String, HelpOptionsType, HelpArgumentsType, HelpSubCommandsType, String).new {{ block.stringify.id }} .call(
            desc,
            usage,
            @options.help_info,
            @arguments.help_info,
            @sub_commands.help_info)
        end
      end
    end

    macro run(&block)
      def run(io : IO)
        opt = @options

        if opt.responds_to?(:help)
          return RunProc.new { io.puts help_template_str }.call(@options, @arguments, io) if opt.help == true
        end

        if opt.responds_to?(:version)
          return RunProc.new { io.puts version }.call(@options, @arguments, io) if opt.version == true
        end

        RunProc.new {{ block.id }} .call(@options, @arguments, io)
      end
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

    private macro option_base(short, long, type, desc, default, required)
      {% raise "Empty option name." if short.empty? %}
      {% raise "Type [#{type}] is not supported on option." unless SUPPORTED_TYPES_OF_OPTION.keys.includes?(type) %}

      {% base_option_name = long == nil ? short : long %}
      {% option_name = base_option_name.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").gsub(/-/, "_").id %}
      class OptionsForEachCommand
        class Option_{{option_name}} < Option
          define_option_macro({{option_name}}, {{type}}, {{default}}, {{required}})

          def method_name : String
            {{option_name.stringify}}
          end
        end

        {% default = false if type.id.stringify == "Bool" && default == nil %}
        {% raise "You can not specify 'required: true' for Bool option." if type.id.stringify == "Bool" && required == true %}

        {% if default == nil %}
          {% default_value = SUPPORTED_TYPES_OF_OPTION[type][:nilable] ? default : SUPPORTED_TYPES_OF_OPTION[type][:default] %}
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

    macro argument(name, type = String, desc = "Argument description.", default = nil, required = false)
      {% raise "Empty argument name." if name.empty? %}
      {% raise "Type [#{type}] is not supported on argument." unless SUPPORTED_TYPES_OF_ARGUMENT.keys.includes?(type) %}

      {% argument_name = name.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").gsub(/-/, "_").id %}
      {% display_name = name.id %}
      class ArgumentsForEachCommand

        \{% if @type.constants.map(&.id.stringify).includes?("Argument_" + {{argument_name.stringify}}.id.stringify) %}
          \{% raise "Argument \"" + {{argument_name.stringify}}.id.stringify + "\" is already defined." %}
        \{% end %}

        class Argument_{{argument_name}} < Argument
          define_argument_macro({{type}}, {{default}}, {{required}})

          def method_name
            {{argument_name.stringify}}
          end
        end

        {% if default == nil %}
          {% default_value = SUPPORTED_TYPES_OF_ARGUMENT[type][:nilable] ? default : SUPPORTED_TYPES_OF_ARGUMENT[type][:default] %}
        {% else %}
          {% default_value = default %}
        {% end %}

        property {{ argument_name }}_instance : Argument_{{argument_name}} = Argument_{{argument_name}}.new({{ argument_name.stringify }}, {{ display_name.stringify }}, {{ desc }}, {{ default_value }}, {{ required }})
        def {{ argument_name }}
          {{ argument_name }}_instance.@value
        end

      end
    end

    macro command(name, &block)
      {% if @type.constants.map(&.id.stringify).includes?("Command_" + name.id.capitalize.stringify) %}
        {% raise "Command \"" + name.id.stringify + "\" is already defined." %}
      {% end %}

      class Command_{{ name.id.capitalize }} < Command

        class Options_{{ name.id.capitalize }} < Options
        end

        class Arguments_{{ name.id.capitalize }} < Arguments
        end

        alias OptionsForEachCommand = Options_{{ name.id.capitalize }}
        alias ArgumentsForEachCommand = Arguments_{{ name.id.capitalize }}
        alias RunProc = Proc(OptionsForEachCommand, ArgumentsForEachCommand, IO, Nil)

        property name : String = {{name.id.stringify}}
        getter usage : String = "#{ {{name.id.stringify}} } [options] [arguments]"

        @options : OptionsForEachCommand
        @arguments : ArgumentsForEachCommand
        @sub_commands : SubCommands

        def initialize(@options : OptionsForEachCommand, @arguments : ArgumentsForEachCommand, @sub_commands : SubCommands = SubCommands.new)
          \{% for command_class in @type.constants.select { |c| @type.constant(c).superclass.id.stringify == "Clim::Command" } %}
            @sub_commands << \{{ command_class.id }}.create
          \{% end %}
        end

        def self.create
          self.new(OptionsForEachCommand.new, ArgumentsForEachCommand.new)
        end

        def parse(argv) : Command
          duplicate_names = (@sub_commands.to_a.map(&.name) + @sub_commands.to_a.map(&.alias_name).flatten).duplicate_value
          raise ClimException.new "There are duplicate registered commands. [#{duplicate_names.join(",")}]" unless duplicate_names.empty?
          recursive_parse(argv)
        end

        def recursive_parse(argv) : Command
          return parse_by_parser(argv) if argv.empty?
          return parse_by_parser(argv) if @sub_commands.find_by_name(argv.first).empty?
          @sub_commands.find_by_name(argv.first).first.recursive_parse(argv[1..-1])
        end

        private def parse_by_parser(argv) : Command
          @options.parse(argv.dup)
          @options.required_validate!
          @options.set_help_string(help_template_str)
          @arguments.set_values_by_input_argument(@options.unknown_args)
          @arguments.set_argv(argv.dup)
          @arguments.required_validate!(@options)
          self
        end

        macro help_macro
          option "--help", type: Bool, desc: "Show this help.", default: false
        end

        {{ yield }}

        \{% raise "'run' block is not defined." unless @type.methods.map(&.name.stringify).includes?("run") %}

        help_macro

      end
    end

    def names
      ([name] + @alias_name)
    end
  end
end
