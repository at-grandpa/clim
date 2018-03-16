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

    macro sub_command(name, &block)
      command({{name}}) do
        {{ yield }}
      end
    end

    macro main_command
      {% if @type.superclass.id.stringify == "Clim::Command" %}
        {% raise "Can not be declared 'main_command' as sub command." %}
      {% end %}
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

    macro option_base(short, long, type, desc, default, required)
      {% if short.empty? %}
        {% raise "Empty option name." %}
      {% end %}

      {% unless SUPPORT_TYPES.includes?(type) %}
        {% raise "Type [#{type}] is not supported on option." %}
      {% end %}

      {% if long == nil %}
        {% base_option_name = short %}
      {% else %}
        {% base_option_name = long %}
      {% end %}
      {% option_name = base_option_name.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").gsub(/-/, "_").id %}
      class OptionsByClim
        class OptionByClim_{{option_name}} < OptionByClim
          option_by_clim_macro({{type}}, {{default}})
        end

        {% default = false if type.id.stringify == "Bool" %}
        {% raise "You can not specify 'required: true' for Bool option." if type.id.stringify == "Bool" && required == true %}
        property {{ option_name }}_instance : OptionByClim_{{option_name}} = OptionByClim_{{option_name}}.new({{ short }}, {% unless long == nil %} {{ long }}, {% end %} {{ desc }}, {{ default }}, {{ required }})
        def {{ option_name }} : {{ type }}?
          {{ option_name }}_instance.@value
        end
      end
    end

    macro option(short, long, type, desc = "Option description.", default = nil, required = false)
      option_base({{short}}, {{long}}, {{type}}, {{desc}}, {{default}}, {{required}})
    end

    macro option(short, type, desc = "Option description.", default = nil, required = false)
      option_base({{short}}, nil, {{type}}, {{desc}}, {{default}}, {{required}})
    end

    macro command(name, &block)
      {% if @type.constants.map(&.id.stringify).includes?("CommandByClim_" + name.id.capitalize.stringify) %}
        {% raise "Command \"" + name.id.stringify + "\" is already defined." %}
      {% end %}

      class CommandByClim_{{ name.id.capitalize }} < Command
        property name : String = {{name.id.stringify}}

        macro run(&block)
          def run(io : IO)
            if @display_help_flag
              RunProc.new { io.puts help }.call(@options, @arguments)
            elsif @display_version_flag
              RunProc.new { io.puts version_str }.call(@options, @arguments)
            else
              RunProc.new \{{ block.id }} .call(@options, @arguments)
            end
          end
        end

        def parse_by_parser(argv)
          @parser.on("--help", "Show this help.") { @display_help_flag = true }
          define_version(@parser)
          @parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
          @parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
          @parser.unknown_args { |unknown_args| @arguments = unknown_args }
          @parser.parse(argv.dup)
          required_validate! unless display_help?
          @options.help = help
          self
        end

        def display_help? : Bool
          @display_help_flag
        end

        class OptionsByClim < Options

          class OptionByClim < Option


            macro option_by_clim_macro(type, default)
              \{% if default == nil %}
                \{% value_type = type.stringify + "?" %}
              \{% else %}
                \{% value_type = type.stringify %}
              \{% end %}

              property default : \{{value_type.id}} = \{{default}}
              property value : \{{value_type.id}} = \{{default}}

              def initialize(@short : String, @long : String, @desc : String, @default : \{{value_type.id}}, @required : Bool)
                @value = default
              end

              def initialize(@short : String, @desc : String, @default : \{{value_type.id}}, @required : Bool)
                @long = nil
                @value = default
              end

              def desc
                desc = @desc
                desc = desc + " [type:#{\{{type}}.to_s}]"
                desc = desc + " [default:#{display_default}]" unless default.nil?
                desc = desc + " [required]" if required
                desc
              end

              def set_value(arg : String)
                \{% type_hash = {
                     "Int8"    => "@value = arg.to_i8",
                     "Int16"   => "@value = arg.to_i16",
                     "Int32"   => "@value = arg.to_i32",
                     "Int64"   => "@value = arg.to_i64",
                     "UInt8"   => "@value = arg.to_u8",
                     "UInt16"  => "@value = arg.to_u16",
                     "UInt32"  => "@value = arg.to_u32",
                     "UInt64"  => "@value = arg.to_u64",
                     "Float32" => "@value = arg.to_f32",
                     "Float64" => "@value = arg.to_f64",
                     "String"  => "@value = arg.to_s",
                     "Bool"    => <<-BOOL_ARG
                    @value = arg.try do |obj|
                      next true if obj.empty?
                      unless obj === "true" || obj == "false"
                        raise ClimException.new "Bool arguments accept only \\"true\\" or \\"false\\". Input: [\#{obj}]"
                      end
                      obj === "true"
                    end
                  BOOL_ARG,
                     "Array(Int8)"    => "add_array_value(Int8, to_i8)",
                     "Array(Int16)"   => "add_array_value(Int16, to_i16)",
                     "Array(Int32)"   => "add_array_value(Int32, to_i32)",
                     "Array(Int64)"   => "add_array_value(Int64, to_i64)",
                     "Array(UInt8)"   => "add_array_value(UInt8, to_u8)",
                     "Array(UInt16)"  => "add_array_value(UInt16, to_u16)",
                     "Array(UInt32)"  => "add_array_value(UInt32, to_u32)",
                     "Array(UInt64)"  => "add_array_value(UInt64, to_u64)",
                     "Array(Float32)" => "add_array_value(Float32, to_f32)",
                     "Array(Float64)" => "add_array_value(Float64, to_f64)",
                     "Array(String)"  => "add_array_value(String, to_s)",
                   } %}
                \{% convert_method = type_hash[type.stringify] %}
                \{{convert_method.id}}
              end
            end
          end
        end

        def initialize
          @display_help_flag = false
          @display_version_flag = false
          @parser = OptionParser.new
          \{% for constant in @type.constants %}
            \{% c = @type.constant(constant) %}
            \{% if c.is_a?(TypeNode) %}
              \{% if c.name.split("::").last == "OptionsByClim" %}
                @options = \{{ c.id }}.new
                @options.setup_parser(@parser)
              \{% elsif c.name.split("::").last == "RunProc" %}
              \{% else %}
                @sub_commands << \{{ c.id }}.new
              \{% end %}
            \{% end %}
          \{% end %}
        end

        def required_validate!
          raise "Required options. \"#{@options.invalid_required_names.join("\", \"")}\"" unless @options.invalid_required_names.empty?
        end

        {{ yield }}

        \{% begin %}
          \{% ccc = @type.constants.select{|c| @type.constant(c).name.split("::").last == "OptionsByClim"}.first %}
          alias RunProc = Proc(\{{ ccc.id }}, Array(String), Nil)
          property options : \{{ ccc.id }} = \{{ ccc.id }}.new

          class \{{ ccc.id }}
            def setup_parser(parser)
              \\{% for iv in @type.instance_vars.reject{|iv| iv.stringify == "help"} %}
                long = \\{{iv}}.long
                if long.nil?
                  parser.on(\\{{iv}}.short, \\{{iv}}.desc) {|arg| \\{{iv}}.set_value(arg) }
                else
                  parser.on(\\{{iv}}.short, long, \\{{iv}}.desc) {|arg| \\{{iv}}.set_value(arg) }
                end
              \\{% end %}
            end

          end
        \{% end %}
      end

    end
  end
end
