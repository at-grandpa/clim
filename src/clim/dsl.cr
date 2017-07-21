require "./command"
require "./options"

class Clim
  alias ReturnOptsType = Hash(String, String | Bool | Array(String) | Nil)
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

  @@main_command : Command = Command.new("main_command")
  @@defining_command : Command = @@main_command
  @@command_stack : Array(Command) = [] of Command

  class Options
    macro string(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def {{property_name.id}}
        values.hash[{{property_name.stringify}}].as(String)
      end
    end

    macro bool(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def {{property_name.id}}
        values.hash[{{property_name.stringify}}].as(Bool)
      end
    end

    macro array(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def {{property_name.id}}
        values.hash[{{property_name.stringify}}].as(Array(String))
      end
    end
  end

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

    #------------------

    macro string(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(String | Nil).new({{short}}, {{long}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.set_string(arg) }
      end
      {{property_name.id}}_define
    end

    macro string(short, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(String | Nil).new({{short}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.set_string(arg) }
      end
      {{property_name.id}}_define
    end

    macro bool(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(Bool | Nil).new({{short}}, {{long}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.set_bool(arg) }
      end
      {{property_name.id}}_define
    end

    macro bool(short, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(Bool | Nil).new({{short}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.set_bool(arg) }
      end
      {{property_name.id}}_define
    end

    macro array(short, long, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(Array(String) | Nil).new({{short}}, {{long}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.add_to_array(arg) }
      end
      {{property_name.id}}_define
    end

    macro array(short, default = nil, required = false, desc = "Option description.")
      {% property_name = long.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Option(Array(String) | Nil).new({{short}}, {{default}}, {{required}}, {{desc}}, {{default}})
        @@defining_command.try &.add_opt(opt) { |arg| opt.add_to_array(arg) }
      end
      {{property_name.id}}_define
    end

    macro options(name)
      class {{name.camelcase.id}} < Clim::Options
        {{yield}}
      end

      def self.{{name.id}}_set_opts
        opts = {{name.camelcase.id}}.new
        if @@defining_command.nil?
          raise "defining_command is nil."
        end
        @@defining_command.try &.opts = opts
      end
      {{name.id}}_set_opts

      {{yield}}
    end

    #------------------

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
