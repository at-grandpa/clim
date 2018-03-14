require "./clim/*"

class Clim
  macro main_command(&block)

    Command.command "main_command_by_clim" do
      {{ yield }}
    end

    {% if @type.constants.map(&.id.stringify).includes?("CommandByClim_Main_command_by_clim") %}
      {% raise "Main command is already defined." %}
    {% end %}

    def self.start(argv, io : IO = STDOUT)
      CommandByClim_Main_command_by_clim.new.parse(argv).run(io)
    end
  end
end
