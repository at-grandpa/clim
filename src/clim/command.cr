require "./dsl"
require "./options"
require "./input_args"
require "./exception"
require "option_parser"

class Clim
  abstract class Command
    property name : String = ""
    property desc : String = "Command Line Interface Tool."
    property usage : String = "{command} [options] [arguments]"
    property args : Array(String) = [] of String
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(Command) = [] of Command

    def initialize_parser
      parser.on("--help", "Show this help.") { }
      parser.invalid_option { |opt_name| raise ClimException.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise ClimException.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
    end

    def set_opts(optsss)
      @opts = optsss
    end

    def get_opts
      @opts
    end

    def add_opt(opt, &proc : String ->)
      if opt.long.empty?
        parser.on(opt.short, opt.desc, &proc)
      else
        parser.on(opt.short, opt.long, opt.desc, &proc)
      end
      @opts.add(opt)
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

    def run(run_proc_opts, run_proc_args)
      @run_proc.call(run_proc_opts, run_proc_args)
    end

    def run_proc_arguments
      return @opts, args
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      sub_cmds = find_sub_cmds_by(argv.first)
      return parse_by_parser(argv) if sub_cmds.empty?
      raise "There are duplicate registered commands. [#{argv.first}]" if sub_cmds.size > 1
      sub_cmds.first.parse(argv[1..-1])
    end

    abstract def parse_by_parser(argv)

    def prepare_parse
      @opts.reset
      args = [] of String
    end

    def find_sub_cmds_by(name)
      sub_cmds.select(&.name.==(name))
    end
  end
end
