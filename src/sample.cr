class ExampleClim
  abstract class Command
    property name : String = ""
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
        end

        def initialize
          \{% for constant in @type.constants %}
            \{% c = @type.constant(constant) %}
            \{% if c.is_a?(TypeNode) %}
              \{% if c.name.split("::").last == "OptionsByClim" %}
                @options = \{{ c.id }}.new
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
        \{% end %}
      end
    end

    macro options(name, type, desc, default, required)
      class OptionsByClim
        property {{ name }} : {{ type }}? = {{ default }}
      end
    end

    abstract def run(str2)

    def find_sub_cmds_by(name)
      @sub_commands.select do |cmd|
        cmd.name == name
      end
    end

    def parse(argv)
      return self if argv.empty?
      return self if find_sub_cmds_by(argv.first).empty?
      find_sub_cmds_by(argv.first).first.parse(argv[1..-1])
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
    options name: "name", type: String, desc: "your name.", default: "Taro", required: true
    run do |options, str2|
      p "main ---"
      p options
      p "---"
    end
    command "sub1" do
      desc "desc sub1."
      options name: "name", type: String, desc: "your name.", default: "Taro", required: true
      run do |options, str2|
        p "sub1 ---"
        p options
        p "---"
      end
      command "subsub1" do
        desc "desc subsub1."
        options name: "name", type: String, desc: "your name.", default: "Taro", required: true
        run do |options, str2|
          p "subsub1 ---"
          p options
          p "---"
        end
      end
    end
  end
end

MyCli.start(ARGV)
