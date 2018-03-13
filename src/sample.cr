require "option_parser"

class ExampleClim
  abstract class Command
    property name : String = ""
    property parser : OptionParser = OptionParser.new
    property args : Array(String) = [] of String
    property sub_commands : Array(Command) = [] of Command

    def desc : String
      ""
    end

    macro desc(description)
      def desc : String
        {{ description.stringify }}
      end
    end

    macro command(name, &block)
      class CommandByClim_{{ name.id.capitalize }} < Command
        property name : String = {{name.id.stringify}}

        macro run(&block)
          def run(str2)
            RunProc.new \{{ block.id }} .call(@options, str2)
          end
        end

        {{ yield }}

        class OptionsByClim
          class OptionByClim(T)
            property short : String = ""
            property long : String = ""
            property desc : String = ""
            property default : T? = nil
            property required : Bool = false
            property value : T? = nil

            def initialize(@short : String, @long : String, @desc : String, @default : T?, @required : Bool)
              @value = default
            end

            def set_value(arg : String)
              \{% begin %}
                \{% type_hash = {
                  Int8   => "to_i8",
                  Int16  => "to_i16",
                  Int32  => "to_i32",
                  String => "to_s",
                  Bool   => "==(\"true\")",
                } %}
                \{% p @type.type_vars %}
                \{% type_ver = @type.type_vars.first %}
                \{% convert_method = type_hash[type_ver] %}
                @value = arg.\{{convert_method.id}}
                p "-------"
                p arg
                p @value
                p self
                p "-------"
              \{% end %}
            end
          end
        end

        def initialize
          \{% for constant in @type.constants %}
            \{% c = @type.constant(constant) %}
            \{% if c.is_a?(TypeNode) %}
              \{% if c.name.split("::").last == "OptionsByClim" %}
                @options = \{{ c.id }}.new
                @options.setup_parser(parser)
                p parser.to_s
              \{% elsif c.name.split("::").last == "RunProc" %}
              \{% else %}
                @sub_commands << \{{ c.id }}.new
              \{% end %}
            \{% end %}
          \{% end %}
        end

        \{% begin %}
          \{% ccc = @type.constants.select{|c| @type.constant(c).name.split("::").last == "OptionsByClim"}.first %}
          alias RunProc = Proc(\{{ ccc.id }}, String, Nil)
          property options : \{{ ccc.id }} = \{{ ccc.id }}.new

          class \{{ ccc.id }}
            def setup_parser(parser)
              \\{% for iv in @type.instance_vars %}
                parser.on(\\{{iv}}.short, \\{{iv}}.long, \\{{iv}}.desc) {|arg| \\{{iv}}.set_value(arg) }
              \\{% end %}
              parser
            end
          end
        \{% end %}
      end
    end

    macro options(short, long, type, desc, default, required)
      class OptionsByClim
        {% long_var_name = long.id.stringify.gsub(/\=/, " ").split(" ").first.id.stringify.gsub(/^--/, "").id %}
        property {{ long_var_name }}_instance : OptionByClim({{ type }}) = OptionByClim({{ type }}).new({{ short }}, {{ long }}, {{ desc }}, {{ default }}, {{ required }})
        def {{ long_var_name }}
          {{ long_var_name }}_instance.@value
        end
      end
    end

    abstract def run(str2)

    def find_sub_cmds_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name
      end
    end

    def parse(argv)
      parser.on("--help", "Show this help.") { @display_help_flag = true }
      parser.invalid_option { |opt_name| raise Exception.new "Undefined option. \"#{opt_name}\"" }
      parser.missing_option { |opt_name| raise Exception.new "Option that requires an argument. \"#{opt_name}\"" }
      parser.unknown_args { |unknown_args| @args = unknown_args }
      recursive_parse(argv)
    end

    def recursive_parse(argv)
      return parse_by_parser(argv) if argv.empty?
      return parse_by_parser(argv) if find_sub_cmds_by(argv.first).empty?
      find_sub_cmds_by(argv.first).first.recursive_parse(argv[1..-1])
    end

    private def parse_by_parser(argv)
      parser.parse(argv.dup)
      # opts.required_validate! unless display_help?
      # opts.help = help
      self
    end
  end

  # ===============================

  macro main_command(&block)
    Command.command "main_command_by_clim" do
      {{ yield }}
    end

    def self.start(argv)
      # argvの残りは、Commandが持っているといいかも
      # そうすると、runを呼ぶだけでいい
      CommandByClim_Main_command_by_clim.new.parse(argv).run("bbb")
    end
  end
end

# あとはバリデーションかなー
# versionとか -> macroですぐにできる
# optionいくか

class MyCli < ExampleClim
  main_command do
    desc "main command."
    options "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
    options "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
    run do |options, str2|
      p "main ---"
      p options
      p options.name
      p options.time
      p "---"
    end
    command "sub1" do
      desc "desc sub1."
      options "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
      options "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
      run do |options, str2|
        p "sub1 ---"
        p options
        p options.name
        p options.time
        p "---"
      end
      command "subsub1" do
        desc "desc subsub1."
        options "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
        options "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
        options "-b", "--bool", type: Bool, desc: "your bool.", default: false, required: true
        run do |options, str2|
          p "subsub1 ---"
          p options
          p options.name
          p options.time
          p options.bool
          p "---"
        end
      end
    end
  end
end

MyCli.start(ARGV)
