class Clim
  abstract class Command
    class Parser(T)
      property option_parser : OptionParser = OptionParser.new
      property arguments : Array(String) = [] of String
      property options : T

      def initialize(@options : T)
        @option_parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
        @option_parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
        @option_parser.unknown_args { |unknown_args| @arguments = unknown_args }
        setup_option_parser(@option_parser)
      end

      def parse(argv : Array(String))
        @option_parser.parse(argv.dup)
      end

      def display_help?
        options = @options
        return false unless options.responds_to?(:help)
        options.help
      end

      def set_help_string(str)
        @options.help_string = str
      end

      def required_validate!
        unless display_help?
          raise "Required options. \"#{options.invalid_required_names.join("\", \"")}\"" unless options.invalid_required_names.empty?
        end
      end

      def setup_option_parser(option_parser)
        # options
        options = @options.to_a
        options.reject { |o| ["help", "version"].includes?(o.method_name) }.each do |option|
          on(option)
        end

        # help
        option_help = options.find { |o| ["help"].includes?(o.method_name) }
        raise ClimException.new("Help option setting is required.") if option_help.nil?
        on(option_help)

        # version
        option_version = options.find { |o| ["version"].includes?(o.method_name) }
        return nil if option_version.nil?
        on(option_version)
      end

      def on(option)
        long = option.long
        if long.nil?
          option_parser.on(option.short, option.desc) { |arg| option.set_value(arg) }
        else
          option_parser.on(option.short, long, option.desc) { |arg| option.set_value(arg) }
        end
      end

      def options_help_info
        option_parser.@flags.map do |flag|
          info = options.info.find do |info|
            !!flag.match(/\A\s+?#{info[:names].join(", ")}/)
          end
          next nil if info.nil?
          info.merge({help_line: flag})
        end.compact
      end
    end
  end
end
