require "./clim/*"

class Clim
  macro main_command(&block)

    Command.command "main_command" do
      {{ yield }}
    end

    {% if @type.constants.map(&.id.stringify).includes?("CommandByClim_Main_command") %}
      {% raise "Main command is already defined." %}
    {% end %}

    def self.start(argv, io : IO = STDOUT)
      CommandByClim_Main_command.new.parse(argv).run(io)
    end
  end
end
