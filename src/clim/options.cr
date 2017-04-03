require "./dsl"
require "./option"

class Clim
  class Options
    alias OptionsType = Option(String) | Option(Bool) | Option(Array(String))

    property opts : Array(OptionsType) = [] of OptionsType
    property help : String = ""

    def add(opt)
      check_short_option_empty!(opt)
      check_short_option_duplication!(opt)
      check_long_option_duplication!(opt)
      opts << opt
    end

    def check_short_option_empty!(opt)
      raise ClimException.new "Empty short option." if opt.short.empty?
    end

    def check_short_option_duplication!(opt)
      if opts.map(&.short).includes?(opt.short)
        raise ClimException.new "Duplicate option. \"#{opt.short}\""
      end
    end

    def check_long_option_duplication!(opt)
      if opts.map(&.long).reject(&.empty?).includes?(opt.long)
        raise ClimException.new "Duplicate option. \"#{opt.long}\""
      end
    end

    class Values
      property help : String = ""

      macro define_methods(*types)
        {% for type in types %}
          {% property_name = type.stringify.split("(").first.downcase %}

          property {{property_name.id}} : Hash(String, {{type.id}}) = {} of String => {{type.id}}

          def {{property_name.split("").first.id}}
              {{property_name.id}}
          end

          def merge!(hash : Hash(String, {{type.id}}))
            {{property_name.id}}.merge!(hash) do |key, _, _|
              raise ClimException.new "Duplicate {{property_name.id}} option. \"#{key}\""
            end
          end
        {% end %}
      end

      define_methods String, Bool, Array(String)
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

    def exists_required!
      invalid_names = [] of String
      opts.each do |opt|
        invalid_names << opt.short if opt.required && !opt.exist
      end
      raise "Required options. \"#{invalid_names.join("\", \"")}\"" unless invalid_names.empty?
    end
  end
end
