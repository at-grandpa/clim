require "./command"

class Clim
  alias ReturnOptsType = Hash(String, String | Bool | Array(String) | Nil)
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

  @@main_command : Command = Command.new("main_command")
  @@defining_command : Command = @@main_command
  @@command_stack : Array(Command) = [] of Command

  module Dsl
    def main_command
      raise ClimException.new "Main command is already defined." unless @@command_stack.empty?
      @@main_command = Command.new("main_command")
      @@defining_command = @@main_command
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
      {% for long? in [true, false] %}
        def {{method_name.id}}(short, {% if long? %} long, {% end %} default : {{type}} = nil, required = false, desc = "Option description.")
          opt = Option({{type}}).new(short, {% if long? %} long, {% else %} "", {% end %} default, required, desc, default)
          @@defining_command.add_opt(opt) {{proc.id}}
        end
      {% end %}
    end

    difine_opts(method_name: "string", type: String | Nil) { |arg| opt.set_string(arg) }
    difine_opts(method_name: "bool", type: Bool | Nil) { |arg| opt.set_bool(arg) }
    difine_opts(method_name: "array", type: Array(String) | Nil) { |arg| opt.add_to_array(arg) }

    class Ttt < Opts
      property(name : String | Nil = nil)
      property(web : Bool | Nil = nil)
      property(dogs : Array(String) | Nil = nil)
    end

    def self.ttt_define_opts
    opt = Option({{type}}).new(short, {% if long? %} long, {% else %} "", {% end %} default, required, desc, default)
    @@defining_command.add_opt(opt) {{proc.id}}
    end

    ttt_define_opts

    def run(&block : RunProc)
      @@defining_command.run_proc = block
      @@command_stack.last.sub_cmds << @@defining_command unless @@command_stack.empty?
    end

    def sub(&block)
      @@command_stack.push(@@defining_command)
      yield
      @@command_stack.pop
    end

    def run_proc_arguments(argv)
      @@main_command.parse(argv).run_proc_arguments
    end

    def start_main(argv)
      run_proc_opts, run_proc_args = run_proc_arguments(argv)
      @@main_command.parse(argv).run(run_proc_opts, run_proc_args)
    end

    def start(argv)
      start_main(argv)
    rescue ex
      puts ex.message
    end
  end
end
