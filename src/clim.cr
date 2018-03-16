require "./clim/*"

class Clim
  SUPPORT_TYPES = [
    Int8,
    Int16,
    Int32,
    Int64,
    UInt8,
    UInt16,
    UInt32,
    UInt64,
    Float32,
    Float64,
    String,
    Bool,
    Array(Int8),
    Array(Int16),
    Array(Int32),
    Array(Int64),
    Array(UInt8),
    Array(UInt16),
    Array(UInt32),
    Array(UInt64),
    Array(Float32),
    Array(Float64),
    Array(String),
  ]

  macro main_command(&block)

    Command.command "main_command" do
      {{ yield }}
    end

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

    {% if @type.constants.map(&.id.stringify).includes?("CommandByClim_Main_command") %}
      {% raise "Main command is already defined." %}
    {% end %}

  end
end
