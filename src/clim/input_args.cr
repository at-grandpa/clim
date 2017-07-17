require "./dsl"
require "./options"
require "./exception"
require "option_parser"

class Clim
  class InputArgs
    property argv : Array(String)

    def initialize(@argv)
    end

    def to_be_exec
      help_arg.empty? ? argv : help_arg
    end

    def help_arg
      argv.select { |arg| arg == "-h" || arg == "--help" }
    end

    def help_arg_only?
      return false if to_be_exec.empty?
      other_arg = to_be_exec.reject { |arg| arg == "-h" || arg == "--help" }
      other_arg.empty?
    end
  end
end
