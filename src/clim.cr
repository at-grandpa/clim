require "./clim/*"

class Clim
  include Types

  alias HelpTemplateType = Proc(String, String, String, String, String)

  DEAFULT_HELP_TEMPLATE = HelpTemplateType.new do |desc, usage, options_help, sub_commands_help|
    base_help_template = <<-HELP_MESSAGE

      #{desc}

      Usage:

        #{usage}

      Options:

    #{options_help}


    HELP_MESSAGE

    sub_commands_help_template = <<-HELP_MESSAGE
      Sub Commands:

    #{sub_commands_help}


    HELP_MESSAGE
    sub_commands_help.empty? ? base_help_template : base_help_template + sub_commands_help_template
  end

  class Clim::Command
    def help_template_def
      help = Help.new(self)
      DEAFULT_HELP_TEMPLATE.call(help.desc, help.usage, help.parser.to_s, help.sub_cmds_help_display)
    end
  end

  macro help_template(&block)
    class Clim::Command
      def help_template_def
        help = Help.new(self)
        Proc(String, String, String, String, String).new {{ block.stringify.id }} .call(help.desc, help.usage, help.parser.to_s, help.sub_cmds_help_display)
      end
    end
  end

  macro main_command(&block)

    Clim::Command.command "main_command_of_clim_library" do
      {{ yield }}
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
