class MyCli < ExampleClim
  class MainCommandByClim < Command
    @name : String = "main_command_by_clim"

    def name : String
      @name
    end

    def name=(name : String)
      @name = name
    end

    macro run(&block)
           def run(str2)
             RunProc.new {{ block.id }} .call(@options, str2)
           end
           end

    def desc : String
      "\"main command.\""
    end

    class OptionsByClim
      property = "Taro"
    end

    def run(str2)
      RunProc.new do |options, str2|
        p("main ---")
        p(options)
        p("---")
      end.call(@options, str2)
    end

    class SubCommandByClim_Sub1 < Command
      @name : String = "sub1"

      def name : String
        @name
      end

      def name=(name : String)
        @name = name
      end

      macro run(&block)
             def run(str2)
               RunProc.new {{ block.id }} .call(@options, str2)
             end
               end

      def desc : String
        "\"desc sub1.\""
      end

      class OptionsByClim
        property = "Taro"
      end

      def run(str2)
        RunProc.new do |options, str2|
          p("sub1 ---")
          p(options)
          p("---")
        end.call(@options, str2)
      end

      class OptionsByClim
      end

      def initialize
        {% for constant in @type.constants %}
               {% c = @type.constant(constant) %}
               {% if c.is_a?(TypeNode) %}
                 {% if (c.name.split("::")).last == "OptionsByClim" %}
                   @options = {{ c.id }}.new
                 {% else %}{% if (c.name.split("::")).last == "RunProc" %}
                 {% else %}
                   @sub_commands << {{ c.id }}.new
                 {% end %}{% end %}
               {% end %}
             {% end %}
      end

      alias RunProc = Proc(OptionsByClim, String, Nil)
      @options : OptionsByClim = OptionsByClim.new

      def options : OptionsByClim
        @options
      end

      def options=(options : OptionsByClim)
        @options = options
      end
    end

    class OptionsByClim
    end

    def initialize
      {% for constant in @type.constants %}
             {% c = @type.constant(constant) %}
             {% if c.is_a?(TypeNode) %}
               {% if (c.name.split("::")).last == "OptionsByClim" %}
                 @options = {{ c.id }}.new
               {% else %}{% if (c.name.split("::")).last == "RunProc" %}
               {% else %}
                 @sub_commands << {{ c.id }}.new
               {% end %}{% end %}
             {% end %}
           {% end %}
    end

    alias RunProc = Proc(OptionsByClim, String, Nil)
    @options : OptionsByClim = OptionsByClim.new

    def options : OptionsByClim
      @options
    end

    def options=(options : OptionsByClim)
      @options = options
    end
  end

  def self.start(argv)
    (MainCommandByClim.new.parse(argv)).run("bbb")
  end
end
