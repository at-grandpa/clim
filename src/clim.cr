require "./clim/*"

class Clim
  include Types

  {% begin %}
  {% support_types = SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
  alias HelpOptionsInfoType = Array(NamedTuple(name: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool))
  {% end %}
  alias HelpOptionsType = NamedTuple(help_lines: Array(String), info: HelpOptionsInfoType)
  alias HelpSubCommandsType = NamedTuple(help_lines: Array(String), info: Array(NamedTuple(name: Array(String), desc: String)))
  alias HelpTemplateType = Proc(String, String, HelpOptionsType, HelpSubCommandsType, String)

  DEAFULT_HELP_TEMPLATE = HelpTemplateType.new do |desc, usage, options, sub_commands|
    base_help_template = <<-HELP_MESSAGE

      #{desc}

      Usage:

        #{usage}

      Options:

    #{options[:help_lines].join("\n")}


    HELP_MESSAGE

    sub_commands_help_template = <<-HELP_MESSAGE
      Sub Commands:

    #{sub_commands[:help_lines].join("\n")}


    HELP_MESSAGE
    sub_commands[:help_lines].empty? ? base_help_template : base_help_template + sub_commands_help_template
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
