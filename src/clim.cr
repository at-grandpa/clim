require "./clim/*"

class Clim
  macro main_command(&block)

    Command.command "main_command" do
      {{ yield }}
    end

    {% if @type.constants.map(&.id.stringify).includes?("CommandByClim_Main_command") %}
      {% raise "Main command is already defined." %}
    {% end %}

    def self.start_parse(argv, io : IO = STDOUT)
      CommandByClim_Main_command.new.parse(argv).run(io)
    end

    def self.start(argv)
      start_parse(argv)
    rescue ex : ClimException
      puts "ERROR: #{ex.message}"
    rescue ex : ClimInvalidOptionException
      puts "ERROR: #{ex.message}"
      puts ""
      puts "Please see the `--help`."
    end
  end
end
