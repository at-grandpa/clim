class Clim
  class Option(T)
    @short : String
    @long : String
    @default : T
    @required : Bool
    @desc : String
    @value : T
    @exist : Bool

    getter short, long, default, required, desc, value, exist

    def initialize(@short, @long, @default, @required, @desc, @value, @exist = false)
    end

    def name
      extract_name(long.empty? ? short : long)
    end

    def extract_name(name)
      name.split(/(\s|=)/).first.gsub(/^-*/, "")
    end

    def to_h
      {name => value}
    end

    def desc
      desc = @desc
      desc = desc + "  [default:#{@default}]" unless @default.to_s.empty?
      desc = desc + "  [required]" if @required
      desc
    end

    def set_value=(arg)
      @exist = true
      @value = arg
    end

    def add_value(arg)
      @exist = true
      @value << arg
    end

    def reset
      @exist = false
      @value = @default.dup
    end
  end
end
