require "./dsl"
require "option_parser"

class Clim
  class Command
    property name : String = ""
    property desc : String = ""
    property usage : String = ""
    property opts : Options = Options.new
    property args : Array(String) = [] of String
    property run_proc : Dsl::RunProc = Dsl::RunProc.new { }
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(self) = [] of self
    property display_help_flag : Bool = false

    def initialize(@name)
      @usage = "#{name} [options] [arguments]"
      initialize_parser
    end

    def initialize_parser
      parser.on("-h", "--help", "Show this help.") { self.display_help_flag = true }
      parser.invalid_option { |opt_name| raise "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| self.args = unknown_args }
    end

    def help
      base_help = <<-HELP_MESSAGE

        #{desc}

        Usage:

          #{usage}

        Options:

      #{parser}


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
      run_cmd = parse(argv)
      proc = run_cmd.display_help_flag ? run_cmd.help_proc : run_cmd.run_proc
      proc.call(run_cmd.opts.values, run_cmd.args)
    end

    def help_proc
      Dsl::RunProc.new { puts help }
    end

    def parse(argv)
      return parse_by_parser(argv) if argv.empty?
      sub_cmds = find_sub_cmds_by(argv.first)
      return parse_by_parser(argv) if sub_cmds.empty?
      raise "There are duplicate registered commands. [#{argv.first}]" if sub_cmds.size > 1
      sub_cmds.first.parse(argv[1..-1])
    end

    def parse_by_parser(argv)
      opts.reset
      parser.parse(argv)
      opts.exists_required! unless display_help_flag
      opts.help = help
      self
    end

    def find_sub_cmds_by(name)
      sub_cmds.select(&.name.==(name))
    end
  end
end
