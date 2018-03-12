class ExampleClim
  class Command
    alias RunProc = Proc(OptionsByClim, String, Nil)
    property name : String = ""
    property options : OptionsByClim = OptionsByClim.new
    property sub_commands : Array(Command) = [] of Command

    def desc : String
      ""
    end

    macro desc(description)
      def desc : String
        {{ description.stringify }}
      end
    end

    def run(str2)
      RunProc.new { }.call(@options, str2)
    end

    macro run(&block)
      def run(str2)
        RunProc.new {{ block.id }} .call(@options, str2)
      end
    end

    macro command(name, &block)
      class SubCommandByClim_{{ name.id.capitalize }} < Command
        property name : String = {{name.id.stringify}}

        {{ yield }}

        class OptionsByClim
        end
      end
    end

    class OptionsByClim
    end

    macro options(name, type, desc, default, required)
      class OptionsByClim
        property {{ name }} : {{ type }}? = {{ default }}
      end
    end

    def initialize
      {% for constant in @type.constants %}
        {% c = @type.constant(constant) %}
        {% if c.is_a?(TypeNode) %}
          {% unless c.name.split("::").last == "OptionsByClim" %}
            @sub_commands << {{ c.id }}.new
          {% end %}
        {% end %}
      {% end %}
      @options = OptionsByClim.new
    end

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
    class MainCommandByClim < Command
      property name : String = "main_command_by_clim"

      {{ yield }}

      class OptionsByClim
      end
    end

    def self.start(argv)
      # argvの残りは、Commandが持っているといいかも
      # そうすると、runを呼ぶだけでいい
      MainCommandByClim.new.parse(argv).run("bbb")
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
        desc "desc subsub1"
        run do |options, str2|
          p "subsub1 ---"
          p options
          p "---"
        end
      end
      command "subsub2" do
        desc "desc subsub2"
        run do |options, str2|
          p "subsub2 ---"
          p options
          p "---"
        end
      end
    end
  end
end

MyCli.start(ARGV)
