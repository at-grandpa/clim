class Clim
  abstract class Command
    module Macros

      macro version(version_str, short = nil)
        {% if short == nil %}
          option "--version", type: Bool, desc: "Show version.", default: false
        {% else %}
          option {{short.id.stringify}}, "--version", type: Bool, desc: "Show version.", default: false
        {% end %}

        def version_str : String
          {{ version_str }}
        end
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
          options = @parser.options
          return RunProc.new { io.puts help_template }.call(options, @parser.arguments, io) if options.help == true

          if options.responds_to?(:version)
            return RunProc.new { io.puts version_str }.call(options, @parser.arguments, io) if options.version == true
          end

          RunProc.new {{ block.id }} .call(options, @parser.arguments, io)
        end
      end

      macro option_base(short, long, type, desc, default, required)
        {% raise "Empty option name." if short.empty? %}
        {% raise "Type [#{type}] is not supported on option." unless SUPPORTED_TYPES_OF_OPTION.keys.includes?(type) %}

        {% base_option_name = long == nil ? short : long %}
        {% option_name = base_option_name.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").gsub(/-/, "_").id %}
        class OptionsForEachCommand
          class Option_{{option_name}} < Option
            define_option_macro({{option_name}}, {{type}}, {{default}}, {{required}})

            def method_name
              {{option_name.stringify}}
            end
          end

          {% default = false if type.id.stringify == "Bool" %}
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

          property parser : Parser(OptionsForEachCommand, ArgumentsForEachCommand)
          property name : String = {{name.id.stringify}}
          property options : OptionsForEachCommand = OptionsForEachCommand.new
          property arguments : ArgumentsForEachCommand = ArgumentsForEachCommand.new

          def initialize(@parser : Parser(OptionsForEachCommand, ArgumentsForEachCommand))
            \{% for command_class in @type.constants.select { |c| @type.constant(c).superclass.id.stringify == "Clim::Command" } %}
              @sub_commands << \{{ command_class.id }}.create
            \{% end %}
          end

          def self.create
            self.new(Parser(OptionsForEachCommand, ArgumentsForEachCommand).new(OptionsForEachCommand.new, ArgumentsForEachCommand.new))
          end

          macro help_macro
            option "--help", type: Bool, desc: "Show this help.", default: false
          end

          {{ yield }}

          help_macro

        end
      end
    end
  end
end
