class Clim
  abstract class Command
    class Parser(T)
      property option_parser : OptionParser = OptionParser.new
      property arguments : Array(String) = [] of String

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

      def options
        @options
      end

      def setup_option_parser(option_parser)
        # options
        options = @options.to_a
        options.to_a.reject { |o| ["help", "version"].includes?(o.method_name) }.each do |option|
          long = option.long
          if long.nil?
            option_parser.on(option.short, option.desc) { |arg| option.set_value(arg) }
          else
            option_parser.on(option.short, long, option.desc) { |arg| option.set_value(arg) }
          end
        end

        # help
        option_found = options.to_a.find { |o| ["help"].includes?(o.method_name) }
        if option_found.nil?
          return nil
        else
          option_help : Clim::Command::Options::Option = option_found
        end
        long = option_help.long
        if long.nil?
          option_parser.on(option_help.short, option_help.desc) do |arg|
            option_help.set_value(arg)
          end
        else
          option_parser.on(option_help.short, long, option_help.desc) do |arg|
            option_help.set_value(arg)
          end
        end

        # version
        option_found = options.to_a.find { |o| ["version"].includes?(o.method_name) }
        if option_found.nil?
          return nil
        else
          option_version : Clim::Command::Options::Option = option_found
        end
        long = option_version.long
        if long.nil?
          option_parser.on(option_version.short, option_version.desc) do |arg|
            option_version.set_value(arg)
          end
        else
          option_parser.on(option_version.short, long, option_version.desc) do |arg|
            option_version.set_value(arg)
          end
        end
      end
    end
  end
end
