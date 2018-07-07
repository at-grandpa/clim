require "./clim/*"

class Clim
  include Types

  class Clim::Command
    def custom_help_def
      help = Help.new(self)
      DEAFULT_HELP_TEMPLATE.call(help.desc, help.usage, help.parser.to_s, help.sub_cmds_help_display)
    end
  end

  macro custom_help(&block)
    class Clim::Command
      def custom_help_def
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
