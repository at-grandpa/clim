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

          {{ yield }}

          def parse_by_parser(argv)
            @parser.on("--help", "Show this help.") { @display_help_flag = true }
            @parser.invalid_option { |opt_name| raise Exception.new "Undefined option. \"#{opt_name}\"" }
            @parser.missing_option { |opt_name| raise Exception.new "Option that requires an argument. \"#{opt_name}\"" }
            @parser.unknown_args { |unknown_args| @arguments = unknown_args }
            @parser.parse(argv.dup)
            # opts.required_validate! unless display_help?
            # opts.help = help
            @options.help = help
            self
          end

          class OptionsByClim
            property help : String = ""

            class OptionByClim(T)
              property short : String = ""
              property long : String? = ""
              property desc : String = ""
              property default : T? = nil
              property required : Bool = false
              property value : T? = nil

              def initialize(@short : String, @long : String, @desc : String, @default : T?, @required : Bool)
                @value = default
              end

              def initialize(@short : String, @desc : String, @default : T?, @required : Bool)
                @long = nil
                @value = default
              end

              def set_value(arg : String)
                \{% begin %}
                  \{% type_hash = {
                    Int8   => "to_i8",
                    Int16  => "to_i16",
                    Int32  => "to_i32",
                    String => "to_s",
                    Bool   => "empty?",
                  } %}
                  \{% type_ver = @type.type_vars.first %}
                  \{% convert_method = type_hash[type_ver] %}
                  @value = arg.\{{convert_method.id}}
                \{% end %}
              end

              def desc
                desc = @desc
                # desc = desc + "  [type:#{T.to_s}]" unless default.nil?
                desc = desc + "  [default:#{display_default}]" unless default.nil?
                desc = desc + "  [required]" if required
                desc
              end

              private def display_default
                default_value = default
                case default_value
                when String
                  default_value.empty? ? "\"\"" : "\"#{default}\""
                when Bool
                  default_value
                when Array(String)
                  default_value.empty? ? "[] of String" : default
                when Nil
                  "nil"
                else
                  raise Exception.new "'default' type is not supported. default type is [#{typeof(default)}]"
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

      macro options(short, long, type, desc = "Option description.", default = nil, required = false)
        class OptionsByClim
          {% long_var_name = long.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").id %}
          property {{ long_var_name }}_instance : OptionByClim({{ type }}) = OptionByClim({{ type }}).new({{ short }}, {{ long }}, {{ desc }}, {{ default }}, {{ required }})
          def {{ long_var_name }} : {{ type }}?
            {{ long_var_name }}_instance.@value
          end
        end
      end

      macro options(short, type, desc = "Option description.", default = nil, required = false)
        class OptionsByClim
          {% short_var_name = short.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^-+/, "").id %}
          property {{ short_var_name }}_instance : OptionByClim({{ type }}) = OptionByClim({{ type }}).new({{ short }}, {{ desc }}, {{ default }}, {{ required }})
          def {{ short_var_name }} : {{ type }}?
            {{ short_var_name }}_instance.@value
          end
        end
      end
    end
  end
end
