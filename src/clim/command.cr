require "./dsl"
require "./options"
require "./exception"
require "option_parser"

class Clim
  class Command
    property name : String = ""
    property desc : String = "Command Line Interface Tool."
    property usage : String = "{command} [options] [arguments]"
    property opts : Options = Options.new
    property args : Array(String) = [] of String
    property run_proc : RunProc = RunProc.new { {% if flag?(:spec) %}  {opts: Hash(String, String | Bool | Array(String) | Nil).new, args: [] of String} {% end %} }
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(self) = [] of self

    def initialize(@name)
      @usage = "#{name} [options] [arguments]"
      initialize_parser
    end

    def initialize_parser
      parser.on("-h", "--help", "Show this help.") { }
      parser.invalid_option { |opt_name| raise ClimException.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise ClimException.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
    end

    def help
      if sub_cmds.empty?
        base_help
      else
        base_help + sub_cmds_help
      end
    end

    def base_help
      <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{parser}


      HELP_MESSAGE
    end

    def sub_cmds_help
      <<-HELP_MESSAGE
        Sub Commands:

      #{sub_cmds_help_lines.join("\n")}


      HELP_MESSAGE
    end

    def sub_cmds_help_lines
      sub_cmds.map do |cmd|
        name = cmd.name + "#{" " * (max_name_length - cmd.name.size)}"
        "    #{name}   #{cmd.desc}"
      end
    end

    def max_name_length
      sub_cmds.empty? ? 0 : sub_cmds.map(&.name.size).max
    end

    def parse_and_run(argv)
      parse(argv).run
    end

    def run
      run_proc.call(opts.values, args)
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      sub_cmds = find_sub_cmds_by(argv.first)
      return parse_by_parser(argv) if sub_cmds.empty?
      raise "There are duplicate registered commands. [#{argv.first}]" if sub_cmds.size > 1
      sub_cmds.first.parse(argv[1..-1])
    end

    def parse_by_parser(argv)
      prepare_parse
      argv = select_help_arg_only(argv)
      parser.parse(argv.dup)
      opts.validate! unless help_arg_only?(argv)
      @run_proc = help_proc if help_arg_only?(argv)
      opts.help = help
      self
    end

    def select_help_arg_only(argv)
      help_arg = argv.select { |arg| arg == "-h" || arg == "--help" }
      if help_arg.empty?
        argv
      else
        help_arg
      end
    end

    def help_arg_only?(argv)
      return false if argv.empty?
      other_arg = argv.reject { |arg| arg == "-h" || arg == "--help" }
      other_arg.empty?
    end

    def prepare_parse
      opts.reset
      @args = [] of String
    end

    def help_proc
      RunProc.new { {% if flag?(:spec) %} {opts: opts.values, args: args} {% else %} puts help {% end %} }
    end

    def find_sub_cmds_by(name)
      sub_cmds.select(&.name.==(name))
    end
  end
end
