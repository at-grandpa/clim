class Clim
  abstract class Command
    module Macro
      macro desc(description)
        def desc : String
          {{ description.id.stringify }}
        end
      end

      macro usage(usage)
        def usage : String
          {{ usage.id.stringify }}
        end
      end

      macro alias_name(*names)
        {% if @type == CommandByClim_Main_command %}
          {% raise "'alias_name' is not supported on main command." %}
        {% end %}
        def alias_name : Array(String)
          {{ names }}.to_a
        end
      end

      macro sub_command(name, &block)
        command({{name}}) do
          {{ yield }}
        end
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
              else
                RunProc.new \{{ block.id }} .call(@options, @arguments)
              end
            end
          end

          def parse_by_parser(argv)
            @parser.on("--help", "Show this help.") { @display_help_flag = true }
            @parser.invalid_option { |opt_name| raise Exception.new "Undefined option. \"#{opt_name}\"" }
            @parser.missing_option { |opt_name| raise Exception.new "Option that requires an argument. \"#{opt_name}\"" }
            @parser.unknown_args { |unknown_args| @arguments = unknown_args }
            @parser.parse(argv.dup)
            required_validate! unless display_help?
            @options.help = help
            self
          end

          def display_help? : Bool
            @display_help_flag
          end

          class OptionsByClim
            property help : String = ""

            def invalid_required_names
              ret = [] of String | Nil
              \{% for iv in @type.instance_vars.reject{|iv| iv.stringify == "help"} %}
                short_or_nil = \{{iv}}.required_set? ? \{{iv}}.short : nil
                ret << short_or_nil
              \{% end %}
              ret.compact
            end

            class OptionByClim
              property short : String = ""
              property long : String? = ""
              property desc : String = ""
              property required : Bool = false
              property array_set_flag : Bool = false

              macro add_array_value(type, cast_method)
                @value = [] of \{{type}} if @array_set_flag == false
                @array_set_flag = true
                @value = @value.nil? ? [arg.\{{cast_method}}] : @value.try &.<<(arg.\{{cast_method}})
              end

              private def display_default
                default_value = default
                {% begin %}
                  case default_value
                  when Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float32, Float64
                    default_value
                  when String
                    default_value.empty? ? "\"\"" : "\"#{default}\""
                  when Bool
                    default_value
                  {% for type in [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float32, Float64, String] %}
                  when Array({{type}})
                    default_value.empty? ? "[] of {{type}}" : default
                  {% end %}
                  when Nil
                    "nil"
                  else
                    raise Exception.new "'default' type is not supported. default type is [#{typeof(default)}]"
                  end
                {% end %}
              end

              def required_set? : Bool
                @required && @value.nil?
              end

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
                          raise Exception.new "Bool arguments accept only \\"true\\" or \\"false\\". Input: [\#{obj}]"
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

      macro option_base(short, long, type, desc, default, required)
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
    end
  end
end
