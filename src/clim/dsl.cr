require "./command"

class Clim
  alias ReturnOptsType = Hash(String, String | Bool | Array(String) | Nil)
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

  @@main_command : Command = Command.new("main_command")
  @@defining_command : Command = @@main_command
  @@command_stack : Array(Command) = [] of Command
  @@defined_main_block : Bool = false

  module Dsl
    def main_command
      raise ClimException.new "Main command is already defined." if @@defined_main_block
      @@main_command = Command.new("main_command")
      @@defining_command = @@main_command
      @@defined_main_block = true
    end

    def command(name)
      raise ClimException.new "Main command is not defined." if @@command_stack.empty?
      @@defining_command = Command.new(name)
    end

    def desc(desc)
      @@defining_command.desc = desc
    end

    def usage(usage)
      @@defining_command.usage = usage
    end

    macro difine_opts(method_name, type, &proc)
      # short name and long name
      def {{method_name.id}}(short, long, default : {{type}} = nil, required = false, desc = "Option description.")
        opt = Option({{type}}).new(short, long, default, required, desc, default)
        @@defining_command.set_opt(opt) {{proc.id}}
      end

      # short name only
      def {{method_name.id}}(short, default : {{type}} = nil, required = false, desc = "Option description.")
        opt = Option({{type}}).new(short,  "", default, required, desc, default)
        @@defining_command.set_opt(opt) {{proc.id}}
      end
    end

    difine_opts(method_name: "string", type: String | Nil) { |arg| opt.set_string(arg) }
    difine_opts(method_name: "bool", type: Bool | Nil) { |arg| opt.set_bool(arg) }
    difine_opts(method_name: "array", type: Array(String) | Nil) { |arg| opt.add_to_array(arg) }

    def run(&block : RunProc)
      @@defining_command.run_proc = block
      @@command_stack.last.add_sub_commands(@@defining_command) unless @@command_stack.empty?
    end

    def sub(&block)
      @@command_stack.push(@@defining_command)
      yield
      @@command_stack.pop
    end

    def run_proc_arguments(argv, root_command = @@main_command)
      root_command.parse(argv).run_proc_arguments
    end

    def start_main(argv, root_command = @@main_command)
      run_proc_opts, run_proc_args = run_proc_arguments(argv, root_command)
      root_command.parse(argv).run(run_proc_opts, run_proc_args)
    end

    def start(argv)
      start_main(argv)
    rescue ex
      puts ex.message
    end
  end
end
