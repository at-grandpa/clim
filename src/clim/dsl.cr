require "./command"

class Clim
  {% if flag?(:spec) %}
    alias ReturnTypeOfRunBlock = NamedTuple(opts: Options::Values, args: Array(String))
    alias RunProc = Proc(Options::Values, Array(String), ReturnTypeOfRunBlock)
  {% else %}
    alias RunProc = Proc(Options::Values, Array(String), Nil)
  {% end %}

  @@main : Command = Command.new("main_command")
  @@defining : Command = @@main
  @@scope_stack : Array(Command) = [] of Command

  module Dsl
    def main_command
      raise ClimException.new "Main command is already defined." unless @@scope_stack.empty?
      @@main = Command.new("main_command")
      @@defining = @@main
    end

    def command(name)
      raise ClimException.new "Main command is not defined." if @@scope_stack.empty?
      @@defining = Command.new(name)
    end

    def desc(desc)
      @@defining.desc = desc
    end

    def usage(usage)
      @@defining.usage = usage
    end

    macro difine_opts(type, default, &proc)
      {% method_name = type.stringify.split("(").first.downcase.id %}

      def {{method_name}}(short, long, default : {{type}} | Nil = nil, required = false, desc = "Option description.")
        if default.nil?
          opt = Option({{type}}).new(short, long, {{default}}, required, desc, {{default}})
          {% if type.id == Bool.id %} opt.set_default_flag = true {% end %}
        else
          opt = Option({{type}}).new(short, long, default, required, desc, default)
          opt.set_default_flag = true
        end
        @@defining.parser.on(opt.short, opt.long, opt.desc) {{proc.id}}
        @@defining.opts.add(opt)
      end

      def {{method_name}}(short, default : {{type}} = {{default}}, required = false, desc = "Option description.")
        if default.nil?
          opt = Option({{type}}).new(short, "", {{default}}, required, desc, {{default}})
          {% if type.id == Bool.id %} opt.set_default_flag = true {% end %}
        else
          opt = Option({{type}}).new(short, "", default, required, desc, default)
          opt.set_default_flag = true
        end
        @@defining.parser.on(opt.short, opt.desc) {{proc.id}}
        @@defining.opts.add(opt)
      end
    end

    difine_opts(type: String, default: "") { |arg| opt.set_string(arg) }
    difine_opts(type: Bool, default: false) { |arg| opt.set_bool(arg) }
    difine_opts(type: Array(String), default: [] of String) { |arg| opt.add_to_array(arg) }

    def run(&block : RunProc)
      @@defining.run_proc = block
      @@scope_stack.last.sub_cmds << @@defining unless @@scope_stack.empty?
    end

    def sub(&block)
      @@scope_stack.push(@@defining)
      yield
      @@scope_stack.pop
    end

    def start_main(argv)
      @@main.parse_and_run(argv)
    end

    def start(argv)
      start_main(argv)
    rescue ex
      puts ex.message
    end
  end
end
