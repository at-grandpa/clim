require "./dsl"
require "./option"

class Clim
  class Options
    alias OptionsType = Option(String | Nil) | Option(Bool | Nil) | Option(Array(String) | Nil)

    property opts : Array(OptionsType) = [] of OptionsType
    property help : String = ""

    def add(opt)
      raise ClimException.new "Empty short option." if opt.short_name.empty?
      raise ClimException.new "Duplicate option. \"-#{opt.short_name}\"" if opts.map(&.short_name).includes?(opt.short_name)
      raise ClimException.new "Duplicate option. \"--#{opt.long_name}\"" if opts.map(&.long_name).reject(&.empty?).includes?(opt.long_name)
      opts << opt
    end

    class Values
      property help : String = ""
      property hash : ReturnOptsType = ReturnOptsType.new

      def merge!(other : ReturnOptsType)
        other.each do |k, v|
          if hash.has_key?(k)
            raise ClimException.new "Duplicate option. \"#{k}\""
          else
            hash.merge!(other)
          end
        end
      end
    end

    def values : ReturnOptsType
      values = Values.new
      values.merge!({"help" => help})
      opts.each do |opt|
        values.merge!(opt.to_h)
      end
      values.hash
    end

    def reset
      opts.each(&.reset)
    end

    def validate!
      raise "Required options. \"#{no_required_option_names.join("\", \"")}\"" unless no_required_option_names.empty?
    end

    def no_value_names
      opts.map do |opt|
        opt.no_value? ? opt.short : nil
      end.compact
    end

    def no_required_option_names
      opts.map do |opt|
        opt.no_required_option? ? opt.short : nil
      end.compact
    end
  end
end
