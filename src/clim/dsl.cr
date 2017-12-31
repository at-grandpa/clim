class Clim
  alias ReturnOptsType = Hash(String, String | Bool | Array(String) | Nil)
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

  @@main : Command = Command.new("main_command") # Main command.
  @@defining : Command = @@main                  # Current defining command.
  @@stack : Array(Command) = [] of Command       # Command stack for `sub do ... end` scope.
  @@defined_main : Bool = false                  # If the main command is defined, @@defined_main = true.

  module Dsl
    def main_command
      raise ClimException.new "Main command is already defined." if @@defined_main
      @@main = Command.new("main_command")
      @@defining = @@main
      @@defined_main = true
    end

    def command(name)
      raise ClimException.new "Main command is not defined." if @@stack.empty?
      @@defining = Command.new(name)
    end

    def alias_name(*name)
      raise ClimException.new "'alias_name' is not supported on main command." if @@stack.empty?
      @@defining.alias_name.concat(name)
    end

    def desc(desc)
      @@defining.desc = desc
    end

    def usage(usage)
      @@defining.usage = usage
    end

    macro difine_opts(method_name, type, &proc)
      # short name and long name
      def {{method_name.id}}(short, long, default : {{type}} = nil, required = false, desc = "Option description.")
        opt = Option({{type}}).new(short, long, default, required, desc, default)
        @@defining.set_opt(opt) {{proc.id}}
      end

      # short name only
      def {{method_name.id}}(short, default : {{type}} = nil, required = false, desc = "Option description.")
        opt = Option({{type}}).new(short,  "", default, required, desc, default)
        @@defining.set_opt(opt) {{proc.id}}
      end
    end

    # Call the define_opts macro.
    difine_opts(method_name: "string", type: String | Nil) { |arg| opt.set_string(arg) }
    difine_opts(method_name: "bool", type: Bool | Nil) { |arg| opt.set_bool(arg) }
    difine_opts(method_name: "array", type: Array(String) | Nil) { |arg| opt.add_to_array(arg) }

    def run(&block : RunProc)
      @@defining.run_proc = block
      @@stack.last.add_sub_commands(@@defining) unless @@stack.empty?
    end

    def sub(&block)
      @@stack.push(@@defining)
      yield
      @@stack.pop
    end

    def run_proc_arguments(argv, root = @@main)
      root.parse(argv).run_proc_arguments
    end

    def start_main(argv, root = @@main)
      opts, args = run_proc_arguments(argv, root)
      root.parse(argv).run(opts, args)
    end

    def start(argv)
      start_main(argv)
    rescue ex : ClimException
      puts "ERROR: #{ex.message}"
    rescue ex : ClimInvalidOptionException
      puts "ERROR: #{ex.message}"
      puts ""
      puts "Please see the `--help`."
    end
  end
end
