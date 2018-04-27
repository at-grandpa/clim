require "./clim/*"

class Clim
  SUPPORT_TYPES_ALL_HASH = {
    Int8 => {
      type:    "number",
      default: 0,
      converter_method: "to_i8",
    },
    Int16 => {
      type:    "number",
      default: 0,
      converter_method: "to_i16",
    },
    Int32 => {
      type:    "number",
      default: 0,
      converter_method: "to_i32",
    },
    Int64 => {
      type:    "number",
      default: 0,
      converter_method: "to_i64",
    },
    UInt8 => {
      type:    "number",
      default: 0,
      converter_method: "to_u8",
    },
    UInt16 => {
      type:    "number",
      default: 0,
      converter_method: "to_u16",
    },
    UInt32 => {
      type:    "number",
      default: 0,
      converter_method: "to_u32",
    },
    UInt64 => {
      type:    "number",
      default: 0,
      converter_method: "to_u64",
    },
    Float32 => {
      type:    "number",
      default: 0.0,
      converter_method: "to_f32",
    },
    Float64 => {
      type:    "number",
      default: 0.0,
      converter_method: "to_f64",
    },
    String => {
      type:    "string",
      default: "",
      converter_method: "to_s",
    },
    Bool => {
      type:    "bool",
      default: false,
    },
    Array(Int8) => {
      type:    "array",
      default: [] of Int8,
    },
    Array(Int16) => {
      type:    "array",
      default: [] of Int16,
    },
    Array(Int32) => {
      type:    "array",
      default: [] of Int32,
    },
    Array(Int64) => {
      type:    "array",
      default: [] of Int64,
    },
    Array(UInt8) => {
      type:    "array",
      default: [] of UInt8,
    },
    Array(UInt16) => {
      type:    "array",
      default: [] of UInt16,
    },
    Array(UInt32) => {
      type:    "array",
      default: [] of UInt32,
    },
    Array(UInt64) => {
      type:    "array",
      default: [] of UInt64,
    },
    Array(Float32) => {
      type:    "array",
      default: [] of Float32,
    },
    Array(Float64) => {
      type:    "array",
      default: [] of Float64,
    },
    Array(String) => {
      type:    "array",
      default: [] of String,
    },
  }

  macro main_command(&block)

    Command.command "main_command_of_clim_library" do
      {{ yield }}
    end

    def self.start_parse(argv, io : IO = STDOUT)
      Command_Main_command_of_clim_library.new.parse(argv).run(io)
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

    {% if @type.constants.map(&.id.stringify).includes?("Command_Main_command_of_clim_library") %}
      {% raise "Main command is already defined." %}
    {% end %}

  end
end
