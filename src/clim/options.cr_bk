class Clim
  class Options
    alias OptionsType = Option(String | Nil) | Option(Bool | Nil) | Option(Array(String) | Nil)

    property opts : Array(OptionsType) = [] of OptionsType
    property help : String = ""

    def add(opt)
      opts << opt
    end

    def to_h : ReturnOptsType
      hash = ReturnOptsType.new
      hash.merge!({"help" => help})
      opts.each do |opt|
        hash.merge!(opt.to_h)
      end
      hash
    end

    def required_validate!
      raise "Required options. \"#{invalid_required_names.join("\", \"")}\"" unless invalid_required_names.empty?
    end

    def opts_validate!
      opts.each do |opt|
        raise ClimException.new "Empty short option." if opt.short_name.empty?
        raise ClimException.new "Duplicate option. \"-#{duplicate_short_name.join(", ")}\"" unless duplicate_short_name.empty?
        raise ClimException.new "Duplicate option. \"--#{duplicate_long_name.join(", ")}\"" unless duplicate_long_name.empty?
      end
    end

    private def duplicate_short_name
      opts.map(&.short_name).duplicate_value
    end

    private def duplicate_long_name
      opts.map(&.long_name).duplicate_value
    end

    private def invalid_required_names
      opts.map do |opt|
        opt.required_set? ? opt.short : nil
      end.compact
    end
  end
end
