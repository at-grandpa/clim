require "./command"

class Clim
  @@main : Command = Command.new("main_command")
  @@defining : Command = @@main
  @@scope_stack : Array(Command) = [] of Command

  module Dsl
    alias RunProc = Proc(Options::Values, Array(String), Nil)

    def main_command
      raise "Main command is already defined." unless @@scope_stack.empty?
      @@main = Command.new("main_command")
      @@defining = @@main
    end

    def command(name)
      raise "Main command is not defined." if @@scope_stack.empty?
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

      def {{method_name}}(short, long, default : {{type}} = {{default}}, required = false, desc = "")
        opt = Option({{type}}).new(short, long, default, required, desc, default)
        @@defining.parser.on(opt.short, opt.long, opt.desc) {{proc.id}}
        @@defining.opts.add(opt)
      end

      def {{method_name}}(short, default : {{type}} = {{default}}, required = false, desc = "")
        opt = Option({{type}}).new(short, "", default, required, desc, default)
        @@defining.parser.on(opt.short, opt.desc) {{proc.id}}
        @@defining.opts.add(opt)
      end
    end

    difine_opts(type: String, default: "") { |arg| opt.set_value = arg }
    difine_opts(type: Bool, default: false) { opt.set_value = true }
    difine_opts(type: Array(String), default: [] of String) { |arg| opt.add_value(arg) }

    def run(&block : RunProc)
      @@defining.run_proc = block
      @@scope_stack.last.sub_cmds << @@defining unless @@scope_stack.empty?
    end

    def sub(&block)
      @@scope_stack.push(@@defining)
      yield
      @@scope_stack.pop
    end

    def start(argv)
      @@main.run(argv)
    rescue ex
      puts ex.message
    end

    def main
      @@main
    end
  end
end
