require "option_parser"

class Clim
  class Command
    property name : String = ""
    property desc : String = "Command Line Interface Tool."
    property usage : String = "{command} [options] [arguments]"
    property opts : Options = Options.new
    property args : Array(String) = [] of String
    property run_proc : RunProc = RunProc.new { }
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(self) = [] of self
    property help_proc : RunProc = RunProc.new { }
    property display_help_flag : Bool = false

    def initialize(@name)
      @usage = "#{name} [options] [arguments]"
      @help_proc = RunProc.new { puts help }
      initialize_parser
    end

    def initialize_parser
      parser.on("--help", "Show this help.") { @run_proc = help_proc; @display_help_flag = true }
      parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
    end

    def set_opt(opt, &proc : String ->)
      opts.add(opt)
      if opt.long.empty?
        parser.on(opt.short, opt.desc, &proc)
      else
        parser.on(opt.short, opt.long, opt.desc, &proc)
      end
    end

    def help
      if sub_cmds.empty?
        base_help
      else
        base_help + sub_cmds_help
      end
    end

    def display_help?
      @display_help_flag
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

    def run(opts, args)
      run_proc.call(opts, args)
    end

    def run_proc_arguments
      return opts.values, args
    end

    def add_sub_commands(cmd)
      raise ClimException.new "There are duplicate registered commands. [#{cmd.name}]" if duplicate_sub_command_name?(cmd.name)
      @sub_cmds << cmd
    end

    def duplicate_sub_command_name?(name)
      !find_sub_cmds_by(name).empty?
    end

    def find_sub_cmds_by(name)
      sub_cmds.select(&.name.==(name))
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) unless duplicate_sub_command_name?(argv.first)
      find_sub_cmds_by(argv.first).first.parse(argv[1..-1])
    end

    def parse_by_parser(argv)
      prepare_parse
      parser.parse(argv.dup)

      opts.validate! unless display_help?

      opts.help = help
      self
    end

    def prepare_parse
      opts.reset
      @args = [] of String
      @display_help_flag = false
    end
  end
end
