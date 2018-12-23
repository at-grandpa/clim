require "./clim/*"

class Clim
  include Types

  {% begin %}
  {% support_types = SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
  alias HelpOptionsType = Array(NamedTuple(names: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool, help_line: String))
  {% end %}
  alias HelpSubCommandsType = Array(NamedTuple(names: Array(String), desc: String, help_line: String))
  alias HelpTemplateType = Proc(String, String, HelpOptionsType, HelpSubCommandsType, String)

  DEAFULT_HELP_TEMPLATE = HelpTemplateType.new do |desc, usage, options, sub_commands|
    options_lines = options.map(&.[](:help_line))
    sub_commands_lines = sub_commands.map(&.[](:help_line))
    base_help_template = <<-HELP_MESSAGE

      #{desc}

      Usage:

        #{usage}

      Options:

    #{options_lines.join("\n")}


    HELP_MESSAGE

    sub_commands_help_template = <<-HELP_MESSAGE
      Sub Commands:

    #{sub_commands_lines.join("\n")}


    HELP_MESSAGE
    sub_commands_lines.empty? ? base_help_template : base_help_template + sub_commands_help_template
  end

  class Clim::Command
    def help_template_def
      help = Help.new(self)
      DEAFULT_HELP_TEMPLATE.call(help.desc, help.usage, help.options, help.sub_commands)
    end
  end

  macro help_template(&block)
    class Clim::Command
      def help_template_def
        help = Help.new(self)
        HelpTemplateType.new {{ block.stringify.id }} .call(help.desc, help.usage, help.options, help.sub_commands)
      end
    end
  end

  macro main(&block)
    main_command do
      {{ yield }}
    end
  end

  macro main_command(&block)

    Clim::Command.command "main_command_of_clim_library" do
      {{ yield }}
    end

    def self.command
      Command_Main_command_of_clim_library.new
    end

    def self.start_parse(argv, io : IO = STDOUT)
      Command_Main_command_of_clim_library.new.parse(argv).run(io)
    end

    def self.start(argv)
      start_parse(argv)
    rescue ex : ClimException
      puts "ERROR: #{ex.message}"
    rescue ex : ClimInvalidOptionException | ClimInvalidTypeCastException
      puts "ERROR: #{ex.message}"
      puts ""
      puts "Please see the `--help`."
    end

    {% if @type.constants.map(&.id.stringify).includes?("Command_Main_command_of_clim_library") %}
      {% raise "Main command is already defined." %}
    {% end %}

  end
end
