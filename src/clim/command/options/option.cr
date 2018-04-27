class Clim
  abstract class Command
    class Options
      class Option
        property short : String = ""
        property long : String? = ""
        property desc : String = ""
        property required : Bool = false
        property array_set_flag : Bool = false

        def required_not_set? : Bool
          @required && !set_value?
        end

        private def display_default
          default_value = @default.dup
          {% begin %}
            {% support_types_number = SUPPORT_TYPES_ALL_HASH.map { |k, v| v[:type] == "number" ? k : nil }.reject(&.==(nil)) %}
            {% support_types_string = SUPPORT_TYPES_ALL_HASH.map { |k, v| v[:type] == "string" ? k : nil }.reject(&.==(nil)) %}
            {% support_types_bool = SUPPORT_TYPES_ALL_HASH.map { |k, v| v[:type] == "bool" ? k : nil }.reject(&.==(nil)) %}
            {% support_types_array = SUPPORT_TYPES_ALL_HASH.map { |k, v| v[:type] == "array" ? k : nil }.reject(&.==(nil)) %}
            case default_value
            when Nil
              "nil"
            when {{*support_types_bool}}
              default_value
            when {{*support_types_string}}
              default_value.empty? ? "\"\"" : "\"#{default_value}\""
            when {{*support_types_number}}
              default_value
            {% for type in support_types_array %}
            when {{type}}
              default_value.empty? ? "[] of {{type.type_vars.first}}" : default
            {% end %}
            else
              raise ClimException.new "[#{typeof(default)}] is not supported."
            end
          {% end %}
        end

        macro define_option_macro(type, default, required)
          {% if default != nil && required == true %}
            {% value_type = type.stringify %}
            {% value_default_value = default %}
            {% value_default_assign = "default".id %}
            {% default_type = type.stringify %}
            {% display_default_on_help_flag = true %}
          {% elsif default != nil && required == false %}
            {% value_type = type.stringify %}
            {% value_default_value = default %}
            {% value_default_assign = "default".id %}
            {% default_type = type.stringify %}
            {% display_default_on_help_flag = true %}
          {% elsif default == nil && required == true %}
            {% value_type = type.stringify %}
            {% value_default_value = SUPPORT_TYPES_ALL_HASH[type][:default] %}
            {% value_default_assign = SUPPORT_TYPES_ALL_HASH[type][:default] %}
            {% default_type = type.stringify + "?" %}
            {% display_default_on_help_flag = false %}
          {% elsif default == nil && required == false %}
            {% value_type = type.stringify + "?" %}
            {% value_default_value = default %}
            {% value_default_assign = "default".id %}
            {% default_type = type.stringify + "?" %}
            {% display_default_on_help_flag = false %}
          {% end %}

          property value : {{value_type.id}} = {{value_default_value}}
          property default : {{default_type.id}} = {{default}}
          property set_value : Bool = false
          property display_default_on_help_flag : Bool = {{display_default_on_help_flag.id}}

          def initialize(@short : String, @long : String, @desc : String, @default : {{default_type.id}}, @required : Bool)
              @value = {{value_default_assign}}
          end

          def initialize(@short : String, @desc : String, @default : {{default_type.id}}, @required : Bool)
            @long = nil
            @value = {{value_default_assign}}
          end

          def desc
            desc = @desc
            desc = desc + " [type:#{{{type}}.to_s}]"
            desc = desc + " [default:#{display_default}]" if display_default_on_help_flag
            desc = desc + " [required]" if required
            desc
          end

          def set_value(arg : String)
            {% raise "Type [#{type}] is not supported on option." unless SUPPORT_TYPES_ALL_HASH.keys.includes?(type) %}
            @value = {{SUPPORT_TYPES_ALL_HASH[type][:convert_arg_process].id}}
            @set_value = true
          end

          def set_value?
            @set_value
          end
        end

        macro add_array_value(type, casted_arg)
          @value = [] of {{type}} if @array_set_flag == false
          @array_set_flag = true
          @value.nil? ? [{{casted_arg}}] : @value.try &.<<({{casted_arg}})
        end
      end
    end
  end
end
