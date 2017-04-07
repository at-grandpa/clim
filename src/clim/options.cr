require "./dsl"
require "./option"

class Clim
  class Options
    alias OptionsType = Option(String) | Option(Bool) | Option(Array(String))

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

      macro define_methods(property_name, type)
        property {{property_name.id}} : Hash(String, {{type.id}}) = {} of String => {{type.id}}

        def {{property_name.split("").first.id}}
          {{property_name.id}}
        end

        def merge!(hash : Hash(String, {{type.id}}))
          {{property_name.id}}.merge!(hash) do |key, _, _|
            raise ClimException.new "Duplicate {{property_name.id}} option. \"#{key}\""
          end
        end
      end

      define_methods(property_name: "string", type: String)
      define_methods(property_name: "bool", type: Bool)
      define_methods(property_name: "array", type: Array(String))
    end

    def values
      values = Values.new
      values.help = help
      opts.each do |opt|
        values.merge!(opt.to_h)
      end
      values
    end

    def reset
      opts.each(&.reset)
    end

    def validate!
      raise "Please specify default value or required true. \"#{no_value_names.join("\", \"")}\"" unless no_value_names.empty?
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
