class Clim
  abstract class Command
    module Macro
      macro desc(description)
        def desc : String
          {{ description.stringify }}
        end
      end

      macro sub_command(name, &block)
        command({{name}}) do
          {{ yield }}
        end
      end

      macro command(name, &block)
        class CommandByClim_{{ name.id.capitalize }} < Command
          property name : String = {{name.id.stringify}}

          macro run(&block)
            def run
              RunProc.new \{{ block.id }} .call(@options, @arguments)
            end
          end

          {{ yield }}

          class OptionsByClim
            class OptionByClim(T)
              property short : String = ""
              property long : String = ""
              property desc : String = ""
              property default : T? = nil
              property required : Bool = false
              property value : T? = nil

              def initialize(@short : String, @long : String, @desc : String, @default : T?, @required : Bool)
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
                  \{% p @type.type_vars %}
                  \{% type_ver = @type.type_vars.first %}
                  \{% convert_method = type_hash[type_ver] %}
                  @value = arg.\{{convert_method.id}}
                  p "-------"
                  p arg
                  p @value
                  p self
                  p "-------"
                \{% end %}
              end
            end
          end

          def initialize
            @parser = OptionParser.new
            \{% for constant in @type.constants %}
              \{% c = @type.constant(constant) %}
              \{% if c.is_a?(TypeNode) %}
                \{% if c.name.split("::").last == "OptionsByClim" %}
                  @options = \{{ c.id }}.new
                  @options.setup_parser(@parser)
                  p @parser.to_s
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
                \\{% for iv in @type.instance_vars %}
                  parser.on(\\{{iv}}.short, \\{{iv}}.long, \\{{iv}}.desc) {|arg| \\{{iv}}.set_value(arg) }
                \\{% end %}
                parser
              end
            end
          \{% end %}
        end
      end

      macro options(short, long, type, desc, default, required)
        class OptionsByClim
          {% long_var_name = long.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^--/, "").id %}
          property {{ long_var_name }}_instance : OptionByClim({{ type }}) = OptionByClim({{ type }}).new({{ short }}, {{ long }}, {{ desc }}, {{ default }}, {{ required }})
          def {{ long_var_name }}
            {{ long_var_name }}_instance.@value
          end
        end
      end
    end
  end
end
