require "./option"

class Clim
  class Options
    alias OptionsType = Option(String | Nil) | Option(Bool | Nil) | Option(Array(String) | Nil)

    property opts : Array(OptionsType) = [] of OptionsType
    property help : String = ""

    def add(opt)
      opt_validate!(opt)
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

    def reset
      opts.each(&.reset)
    end

    def validate!
      raise "Required options. \"#{invalid_required_names.join("\", \"")}\"" unless invalid_required_names.empty?
    end

    private def opt_validate!(opt)
      raise ClimException.new "Empty short option." if opt.short_name.empty?
      raise ClimException.new "Duplicate option. \"-#{opt.short_name}\"" if duplicate_short_name?(opt.short_name)
      raise ClimException.new "Duplicate option. \"--#{opt.long_name}\"" if duplicate_long_name?(opt.long_name)
    end

    private def duplicate_short_name?(name)
      opts.map(&.short_name).includes?(name)
    end

    private def duplicate_long_name?(name)
      opts.map(&.long_name).reject(&.empty?).includes?(name)
    end

    private def invalid_required_names
      opts.map do |opt|
        opt.required_set? ? opt.short : nil
      end.compact
    end
  end
end
