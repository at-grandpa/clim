require "./dsl"

class Clim
  class Command
    @name : String = ""
    @desc : String = ""
    @usage : String = ""
    @opts : Options = Options.new
    @args : Array(String) = [] of String
    @run_proc : Dsl::RunProc = Dsl::RunProc.new { }
    @parser : OptionParser = OptionParser.new
    @sub_cmds : Array(self) = [] of self
    @display_help_flag : Bool = false

    property name, desc, usage, opts, args, run_proc, parser, sub_cmds, display_help_flag

    def initialize(@name)
      @usage = "#{@name} [options] [arguments]"
      @parser = OptionParser.new
      @parser.on("-h", "--help", "Show this help.") { self.display_help_flag = true }
      @parser.invalid_option { |name| raise "Undefined option. \"#{name}\"" }
      @parser.missing_option { |name| raise "Option that requires an argument. \"#{name}\"" }
      @parser.unknown_args { |unknown_args| self.args = unknown_args }
    end

    def check_required
      required_names = [] of String
      @opts.all.each do |opt|
        required_names << opt.short if opt.required && !opt.exist
      end
      raise "Required options. \"#{required_names.join("\", \"")}\"" unless required_names.empty?
    end

    def help
      base_help = <<-HELP_MESSAGE

        #{@desc}

        Usage:

          #{@usage}

        Options:

      #{@parser}


      HELP_MESSAGE

      sub_cmds.empty? ? base_help : base_help + sub_cmds_help
    end

    def sub_cmds_help
      sub_cmds_help = [] of String
      sub_cmds.map do |cmd|
        name = cmd.name + "#{" " * (max_name_length - cmd.name.size)}"
        sub_cmds_help << "    #{name}   #{cmd.desc}"
      end
      <<-HELP_MESSAGE
        Sub Commands:

      #{sub_cmds_help.join("\n")}


      HELP_MESSAGE
    end

    def max_name_length
      return 0 if sub_cmds.empty?
      sub_cmds.map(&.name.size).max
    end

    def run(argv)
      cmd = parse(argv)
      proc = cmd.display_help_flag ? cmd.help_proc : cmd.run_proc
      cmd.opts.set_help(cmd.help)
      proc.call(cmd.opts.values, cmd.args)
    end

    def help_proc
      Dsl::RunProc.new { puts help }
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      cmds = find_sub_cmds_by(argv.first)
      return parse_by_parser(argv) if cmds.empty?
      raise "There are duplicate registered commands. [#{argv.first}]" if cmds.size > 1
      cmds.first.parse(argv[1..-1])
    end

    def parse_by_parser(argv)
      opts.reset
      parser.parse(argv)
      check_required unless display_help_flag
      self
    end

    def find_sub_cmds_by(name)
      sub_cmds.select do |sub_cmd|
        sub_cmd.name == name
      end
    end
  end
end
