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
      end
    end
  end
end
