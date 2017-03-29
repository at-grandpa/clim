require "./dsl"

class Clim
  class Options
    def initialize
      @opts = [] of Dsl::OptionsType
      @help = ""
    end

    def add(opt)
      @opts << opt
    end

    def all
      @opts
    end

    def set_help(help)
      @help = help
    end

    class Values
      @string : Hash(String, String)
      @bool : Hash(String, Bool)
      @array : Hash(String, Array(String))
      @help : String

      property string, bool, array, help

      def initialize
        @string = {} of String => String
        @bool = {} of String => Bool
        @array = {} of String => Array(String)
        @help = ""
      end

      def s; @string; end
      def b; @bool; end
      def a; @array; end
    end

    def values
      hash = {} of String => Dsl::Types
      values = Values.new
      values.help = @help
      @opts.each do |opt|
        name = opt.long.empty? ? opt.short : opt.long
        value = opt.value
        case
        when value.is_a?(String)
          values.string.merge!({extract_opt_name(name) => value})
        when value.is_a?(Bool)
          values.bool.merge!({extract_opt_name(name) => value})
        when value.is_a?(Array(String))
          values.array.merge!({extract_opt_name(name) => value})
        else
          raise "Invalid option type."
        end
      end
      values
    end

    def extract_opt_name(name)
      name.split(/(\s|=)/).first.gsub(/^-*/, "")
    end

    def reset
      @opts.each(&.reset)
    end
  end
end
