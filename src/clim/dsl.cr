require "./command"
require "./options"

class Clim

  alias ReturnOptsType = Options
  alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

  class Options
    macro desc(desc)
    end

    macro usage(usage)
    end

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

    macro run(&proc)
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

    macro string(short, long, default = nil, required = false, desc = "Option description.")
    end

    macro bool(short, long, default = nil, required = false, desc = "Option description.")
    end

    macro array(short, long, default = nil, required = false, desc = "Option description.")
    end

    macro run(&block)
      def set_run_proc(&block : RunProc)
        @run_proc = block
      end
    end
  end

  module Dsl
    macro desc(desc)
    end

    macro usage(usage)
    end

    # 全runコマンドで共通
    # def set_run_proc(&block : RunProc)
      # @@defining_command.run_proc = block
      # @@command_stack.last.sub_cmds << @@defining_command unless @@command_stack.empty?
    # end

    # macro run(&block)
      # set_run_proc {{block.id}}
    # end

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

    macro main_command
      {% name = "main_command" %}
      class {{name.camelcase.id}}Options < Clim::Options
        {{yield}}
      end

      def self.{{name.id}}_set_opts
        opts = {{name.camelcase.id}}Options.new
        if @@defining_command.nil?
          raise "defining_command is nil."
        end
        @@defining_command.try &.set_opts(opts)
      end

      class {{name.camelcase.id}} < Clim::Command
        alias ReturnOptsType = {{name.camelcase.id}}Options
        alias RunProc = Proc(ReturnOptsType, Array(String), Nil)

        @opts : {{name.camelcase.id}}Options
        @run_proc : RunProc = RunProc.new { }

        def initialize(@name, @opts : {{name.camelcase.id}}Options)
          @desc = "Command Line Interface Tool."
          @args = [] of String
          @run_proc = RunProc.new { }
          @parser = OptionParser.new
          @sub_cmds = [] of Command
          @usage = "#{name} [options] [arguments]"
          initialize_parser
        end

        def run_proc=(proc : RunProc)
          @run_proc = proc
        end

        # helpのRunProcをどうにか排除したい

        def parse_by_parser(argv)
          input_args = InputArgs.new(argv)

          prepare_parse
          parser.parse(input_args.to_be_exec.dup)

          if input_args.include_help_arg?
            @run_proc = RunProc.new { puts help }
          else
            @opts.validate!
          end

          @opts.help = help
          self
        end

        {{yield}}
      end

      def self.{{name.id}}_set_command
        raise ClimException.new "Main command is already defined." unless @@command_stack.empty?
        @@main_command = {{name.camelcase.id}}.new("main_command", {{name.camelcase.id}}Options.new)
        @@defining_command = @@main_command
      end

      def self.run(&block : Proc({{name.camelcase.id}}Options, Array(String), Nil))
        @@defining_command.run_proc = block
        @@command_stack.last.sub_cmds << @@defining_command unless @@command_stack.empty?
      end

      @@main_command : {{name.camelcase.id}} = {{name.camelcase.id}}.new("main_command", {{name.camelcase.id}}Options.new)
      @@defining_command : {{name.camelcase.id}} = @@main_command
      @@command_stack : Array(Command) = [] of Command

      {{name.id}}_set_opts
      {{name.id}}_set_command

      {{yield}}
    end

    # macro run(&block)
      # set_run_proc {{block.id}}
    # end
  end
end
