class Clim
  abstract class Command
    class Options
      class Option
        property short : String = ""
        property long : String? = ""
        property desc : String = ""
        property required : Bool = false
        property array_set_flag : Bool = false

        macro add_array_value(type, cast_method)
          @value = [] of {{type}} if @array_set_flag == false
          @array_set_flag = true
          @value = @value.nil? ? [arg.{{cast_method}}] : @value.try &.<<(arg.{{cast_method}})
        end

        def required_set? : Bool
          @required && @value.nil?
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
              raise ClimException.new "[#{typeof(default)}] is not supported."
            end
          {% end %}
        end

        macro option_by_clim_macro(type, default)
          {% if default == nil %}
            {% value_type = type.stringify + "?" %}
          {% else %}
            {% value_type = type.stringify %}
          {% end %}

          property default : {{value_type.id}} = {{default}}
          property value : {{value_type.id}} = {{default}}

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
            desc = desc + " [default:#{display_default}]" unless default.nil?
            desc = desc + " [required]" if required
            desc
          end

          def set_value(arg : String)
            {% type_hash = {
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
            {% convert_method = type_hash[type.stringify] %}
            {{convert_method.id}}
          end
        end
      end
    end
  end
end
