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
    property run_proc : RunProc = RunProc.new { {% if flag?(:spec) %}  {opts: Options::Values.new, args: [] of String} {% end %} }
    property parser : OptionParser = OptionParser.new
    property sub_cmds : Array(self) = [] of self
    property display_help_flag : Bool = false

    def initialize(@name)
      @usage = "#{name} [options] [arguments]"
      initialize_parser
    end

    def initialize_parser
      parser.on("-h", "--help", "Show this help.") { @display_help_flag = true }
      parser.invalid_option { |opt_name| raise ClimException.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise ClimException.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
    end

    def help
      sub_cmds.empty? ? base_help : base_help + sub_cmds_help
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
      parser.parse(argv)
      opts.validate! unless @display_help_flag
      @run_proc = help_proc if @display_help_flag
      opts.help = help
      self
    end

    def prepare_parse
      opts.reset
      @display_help_flag = false
      @args = [] of String
    end

    def help_proc
      RunProc.new { {% if flag?(:spec) %} {opts: opts.values, args: args} {% else %} puts help {% end %} }
    end

    def find_sub_cmds_by(name)
      sub_cmds.select(&.name.==(name))
    end

    macro define_add_opt(type, &proc)
      def add_opt(short, long, default : {{type}}, required, desc, value : {{type}}, set_default_flag = false)
        opt = Option({{type}}).new(short, long, default, required, desc, value)
        opt.set_default_flag = {% if type.id == Bool.id %} true {% else %} set_default_flag {% end %}
        @parser.on(opt.short, opt.long, opt.desc) {{proc.id}}
        @opts.add(opt)
      end

      def add_opt(short, default : {{type}}, required, desc, value : {{type}}, set_default_flag = false)
        opt = Option({{type}}).new(short, "", default, required, desc, value)
        opt.set_default_flag = {% if type.id == Bool.id %} true {% else %} set_default_flag {% end %}
        @parser.on(opt.short, opt.desc) {{proc.id}}
        @opts.add(opt)
      end
    end

    define_add_opt(type: String) { |arg| opt.set_string(arg) }
    define_add_opt(type: Bool) { |arg| opt.set_bool(arg) }
    define_add_opt(type: Array(String)) { |arg| opt.add_to_array(arg) }
  end
end
