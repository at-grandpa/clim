require "option_parser"
require "./dsl"
require "./exception"
require "./options"

class Clim
  class Command
    property name : String = ""
    property alias_name : Array(String) = [] of String
    property desc : String = "Command Line Interface Tool."
    property usage : String = "{command} [options] [arguments]"
    property opts : Options = Options.new
    property args : Array(String) = [] of String
    property run_proc : RunProc = RunProc.new { }
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(self) = [] of self
    property display_help_flag : Bool = false

    def initialize(@name)
      @usage = "#{name} [options] [arguments]"

      # initialize parser
      parser.on("--help", "Show this help.") { @display_help_flag = true }
      parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
    end

    def set_opt(opt, &proc : String ->)
      opt.set_proc(&proc)
      opts.add(opt)
    end

    def help
      sub_cmds.empty? ? base_help : base_help + sub_cmds_help
    end

    def run(io)
      select_run_proc(io).call(opts.to_h, args)
    end

    def add_sub_commands(cmd)
      @sub_cmds << cmd
    end

    def parse(argv)
      validate!
      set_opts_on_parser
      recursive_parse(argv)
    end

    private def validate!
      opts.opts_validate!
      raise ClimException.new "There are duplicate registered commands. [#{duplicate_names.join(",")}]" unless duplicate_names.empty?
    end

    private def duplicate_names
      names = @sub_cmds.map(&.name)
      alias_names = @sub_cmds.map(&.alias_name).flatten
      (names + alias_names).duplicate_value
    end

    private def set_opts_on_parser
      opts.opts.each do |opt|
        if opt.long.empty?
          parser.on(opt.short, opt.desc, &(opt.proc))
        else
          parser.on(opt.short, opt.long, opt.desc, &(opt.proc))
        end
      end
    end

    def recursive_parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) if find_sub_cmds_by(argv.first).empty?
      find_sub_cmds_by(argv.first).first.recursive_parse(argv[1..-1])
    end

    private def display_help?
      @display_help_flag
    end

    private def base_help
      <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{parser}


      HELP_MESSAGE
    end

    private def sub_cmds_help
      <<-HELP_MESSAGE
        Sub Commands:

      #{sub_cmds_help_lines.join("\n")}


      HELP_MESSAGE
    end

    private def sub_cmds_help_lines
      sub_cmds.map do |cmd|
        name = name_and_alias_name(cmd) + "#{" " * (max_name_length - name_and_alias_name(cmd).size)}"
        "    #{name}   #{cmd.desc}"
      end
    end

    private def max_name_length
      sub_cmds.empty? ? 0 : sub_cmds.map { |cmd| name_and_alias_name(cmd).size }.max
    end

    private def name_and_alias_name(cmd)
      ([cmd.name] + cmd.alias_name).join(", ")
    end

    private def select_run_proc(io)
      display_help? ? RunProc.new { io.puts help } : @run_proc
    end

    private def find_sub_cmds_by(name)
      sub_cmds.select do |cmd|
        cmd.name == name || cmd.alias_name.includes?(name)
      end
    end

    private def parse_by_parser(argv)
      parser.parse(argv.dup)
      opts.required_validate! unless display_help?
      opts.help = help
      self
    end
  end
end
