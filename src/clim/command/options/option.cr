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
            case default_value
            when Nil
              "nil"
            when {{*SUPPORT_TYPES_BOOL}}
              default_value
            when {{*SUPPORT_TYPES_STRING}}
              default_value.empty? ? "\"\"" : "\"#{default_value}\""
            when {{*(SUPPORT_TYPES_INT + SUPPORT_TYPES_UINT + SUPPORT_TYPES_FLOAT)}}
              default_value
            {% for type in (SUPPORT_TYPES_INT + SUPPORT_TYPES_UINT + SUPPORT_TYPES_FLOAT + SUPPORT_TYPES_STRING) %}
            when Array({{type}})
              default_value.empty? ? "[] of {{type}}" : default
            {% end %}
            else
              raise ClimException.new "[#{typeof(default)}] is not supported."
            end
          {% end %}
        end

        macro define_option_macro(type, default, required)
          {% if default == nil && required == false %}
            {% display_default_on_help_flag = false %}
            {% value_type = type.stringify + "?" %}
            {% default_value = nil %}
          {% elsif default == nil && required == true %}
            {% display_default_on_help_flag = false %}
            {% value_type = type.stringify %}
            {% default_value = SUPPORT_TYPES_ALL_HASH[type][:default] %}
          {% else %}
            {% display_default_on_help_flag = true %}
            {% value_type = type.stringify %}
            {% default_value = SUPPORT_TYPES_ALL_HASH[type][:default] %}
          {% end %}

          property default : {{value_type.id}} = {{default_value}}
          property value : {{value_type.id}} = {{default_value}}
          property set_value : Bool = false
          property display_default_on_help_flag : Bool = {{display_default_on_help_flag.id}}

          def initialize(@short : String, @long : String, @desc : String, @default : {{value_type.id}}, @required : Bool)
            @value = default
          end

          def initialize(@short : String, @desc : String, @default : {{value_type.id}}, @required : Bool)
            @long = nil
            @value = default
          end

          def desc
            desc = @desc
            desc = desc + " [type:#{{{type}}.to_s}]"
            desc = desc + " [default:#{display_default}]" if display_default_on_help_flag
            desc = desc + " [required]" if required
            desc
          end

          def set_value(arg : String)
            {% if type.id == Int8.id %}
              @value = arg.to_i8
            {% elsif type.id == Int16.id %}
              @value = arg.to_i16
            {% elsif type.id == Int32.id %}
              @value = arg.to_i32
            {% elsif type.id == Int64.id %}
              @value = arg.to_i64
            {% elsif type.id == UInt8.id %}
              @value = arg.to_u8
            {% elsif type.id == UInt16.id %}
              @value = arg.to_u16
            {% elsif type.id == UInt32.id %}
              @value = arg.to_u32
            {% elsif type.id == UInt64.id %}
              @value = arg.to_u64
            {% elsif type.id == Float32.id %}
              @value = arg.to_f32
            {% elsif type.id == Float64.id %}
              @value = arg.to_f64
            {% elsif type.id == String.id %}
              @value = arg.to_s
            {% elsif type.id == Bool.id %}
              @value = arg.try do |obj|
                next true if obj.empty?
                unless obj === "true" || obj == "false"
                  raise ClimException.new "Bool arguments accept only \"true\" or \"false\". Input: [#{obj}]"
                end
                obj === "true"
              end
            {% elsif type.id == "Array(Int8)".id %}
              add_array_value(Int8, to_i8)
            {% elsif type.id == "Array(Int16)".id %}
              add_array_value(Int16, to_i16)
            {% elsif type.id == "Array(Int32)".id %}
              add_array_value(Int32, to_i32)
            {% elsif type.id == "Array(Int64)".id %}
              add_array_value(Int64, to_i64)
            {% elsif type.id == "Array(UInt8)".id %}
              add_array_value(UInt8, to_u8)
            {% elsif type.id == "Array(UInt16)".id %}
              add_array_value(UInt16, to_u16)
            {% elsif type.id == "Array(UInt32)".id %}
              add_array_value(UInt32, to_u32)
            {% elsif type.id == "Array(UInt64)".id %}
              add_array_value(UInt64, to_u64)
            {% elsif type.id == "Array(Float32)".id %}
              add_array_value(Float32, to_f32)
            {% elsif type.id == "Array(Float64)".id %}
              add_array_value(Float64, to_f64)
            {% elsif type.id == "Array(String)".id %}
              add_array_value(String, to_s)
            {% else %}
              {% raise "Type [#{type}] is not supported on option." %}
            {% end %}
            @set_value = true
          end

          def set_value?
            @set_value
          end
        end

        macro add_array_value(type, cast_method)
          @value = [] of {{type}} if @array_set_flag == false
          @array_set_flag = true
          @value = @value.nil? ? [arg.{{cast_method}}] : @value.try &.<<(arg.{{cast_method}})
        end
      end
    end
  end
end
