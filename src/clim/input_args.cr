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
      select_help_arg.empty? ? argv : select_help_arg
    end

    def select_help_arg
      argv.select { |arg| arg == "--help" }
    end

    def include_help_arg?
      return false if to_be_exec.empty?
      other_arg = to_be_exec.reject { |arg| arg == "--help" }
      other_arg.empty?
    end
  end
end
