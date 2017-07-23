require "./command"
require "./options"

class Clim
  alias ReturnOptsType = Clim::Options
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

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

  class Command
    macro desc(desc)
      def desc
        {{desc}}
      end
    end

    macro usage(usage)
      def usage
        {{usage}}
      end
    end

    macro options(name)
    end

    macro run(&block)
      def set_run_proc(&block : RunProc)
        @run_proc = block
      end
    end

  end

  module Dsl

    macro main_command
      @@main_command : Command = Command.new("main_command")
      @@defining_command : Command = @@main_command
      @@command_stack : Array(Command) = [] of Command

      class {{"main_command".camelcase.id}} < Clim::Command
        {{yield}}
      end

      def self.{{"main_command".id}}_set_command
        raise ClimException.new "Main command is already defined." unless @@command_stack.empty?
        @@main_command = {{"main_command".camelcase.id}}.new("main_command")
        @@defining_command = @@main_command
      end
      {{"main_command".id}}_set_command

      {{yield}}
    end

    macro desc(desc)
    end

    macro usage(usage)
    end

    # 全runコマンドで共通
    def set_run_proc(&block : RunProc)
      @@defining_command.run_proc = block
      @@command_stack.last.sub_cmds << @@defining_command unless @@command_stack.empty?
    end

    macro run(&block)
      set_run_proc {{block.id}}
    end

    macro command(name)
      {% normalize_name = name.split("=").first.split(" ").first.gsub(/^-*/, "").gsub(/-/, "_") %}
      def command_{{normalize_name.id}}
        raise ClimException.new "Main command is not defined." if @@command_stack.empty?
        @@defining_command = Command.new({{normalize_name.stringify}})
      end
      command_{{normalize_name.id}}
    end

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
        @@defining_command.try &.set_opts(opts)
      end
      {{name.id}}_set_opts

      {{yield}}
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

    # うへーーーー
    # commandsも、定義別にやらねばならない
    # OptionsのUnionを吸収できない
    # もうなんか、定義毎に、まじで全部macroだな

    # main_command do
      # desc "test command"
      # usage "command usage"
      # options(name: "eee") do
        # string "-n NAME", "--name=NAME"
        # bool "-w", "--web"
        # array "-d DOGS", "--dogs=DOGS"
      # end
      # run do |opts, args|
        # puts "aaa"
      # end
    # end


#      usage "test [options]"
#      options do
#        string "-n NAME", "--name=NAME"
#        array "-d DOGS", "--dogs=DOGS"
#      end
#      run do |opts, args|
#        puts "aaa"
#      end
    #------------------

  end
end

