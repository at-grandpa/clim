class Clim
  class Option(T)
    property short : String
    property long : String
    property default : T
    property required : Bool
    property desc : String
    property value : T

    def initialize(@short, @long, @default, @required, @desc, @value)
    end

    def name
      long.empty? ? short_name : long_name
    end

    def short_name
      extract_name(short)
    end

    def long_name
      extract_name(long)
    end

    def extract_name(name)
      name.split(/(\s|=)/).first.gsub(/^-*/, "")
    end

    def to_h
      {name => value}
    end

    def desc
      desc = @desc
      desc = desc + "  [default:#{display_default}]" unless default.nil?
      desc = desc + "  [required]" if required
      desc
    end

    def display_default
      default_value = default
      case default_value
      when String
        default_value.empty? ? "\"\"" : default
      when Bool
        default_value
      when Array(String)
        default_value.empty? ? "[] of String" : default
      when Nil
        "nil"
      else
        raise ClimException.new "'default' type is not supported. default type is [#{typeof(default)}]"
      end
    end

    def set_string(@value)
    end

    def set_bool(arg)
      if arg.empty?
        @value = true
      else
        unless arg === "true" || arg == "false"
          raise ClimException.new "Bool arguments accept only \"true\" or \"false\". Input: [#{arg}]"
        end
        @value = arg === "true"
      end
    end

    def add_to_array(arg)
      @value = @value.nil? ? [arg] : @value.try &.<<(arg)
    end

    def reset
      @value = @default.dup
    end

    def required_set?
      @required && @value.nil?
    end
  end
end
