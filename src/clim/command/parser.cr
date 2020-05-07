require "../exception"
require "option_parser"

class Clim
  abstract class Command
    class Parser
      @option_parser : OptionParser
      @unknown_args : Array(String)

      def initialize(@option_parser : OptionParser)
        @unknown_args = [] of String
        @option_parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
        @option_parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
        @option_parser.unknown_args { |ua| @unknown_args = ua }
      end
    end
  end
end
