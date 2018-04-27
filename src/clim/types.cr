class Clim
  module Types
    SUPPORT_TYPES_ALL_HASH = {
      Int8 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_i8",
      },
      Int16 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_i16",
      },
      Int32 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_i32",
      },
      Int64 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_i64",
      },
      UInt8 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_u8",
      },
      UInt16 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_u16",
      },
      UInt32 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_u32",
      },
      UInt64 => {
        type:                "number",
        default:             0,
        convert_arg_process: "arg.to_u64",
      },
      Float32 => {
        type:                "number",
        default:             0.0,
        convert_arg_process: "arg.to_f32",
      },
      Float64 => {
        type:                "number",
        default:             0.0,
        convert_arg_process: "arg.to_f64",
      },
      String => {
        type:                "string",
        default:             "",
        convert_arg_process: "arg.to_s",
      },
      Bool => {
        type:                "bool",
        default:             false,
        convert_arg_process: <<-PROCESS
      arg.try do |obj|
        next true if obj.empty?
        unless obj === "true" || obj == "false"
          raise ClimException.new "Bool arguments accept only \\"true\\" or \\"false\\". Input: [\#{obj}]"
        end
        obj === "true"
      end
      PROCESS,
      },
      Array(Int8) => {
        type:                "array",
        default:             [] of Int8,
        convert_arg_process: "add_array_value(Int8, arg.to_i8)",
      },
      Array(Int16) => {
        type:                "array",
        default:             [] of Int16,
        convert_arg_process: "add_array_value(Int16, arg.to_i16)",
      },
      Array(Int32) => {
        type:                "array",
        default:             [] of Int32,
        convert_arg_process: "add_array_value(Int32, arg.to_i32)",
      },
      Array(Int64) => {
        type:                "array",
        default:             [] of Int64,
        convert_arg_process: "add_array_value(Int64, arg.to_i64)",
      },
      Array(UInt8) => {
        type:                "array",
        default:             [] of UInt8,
        convert_arg_process: "add_array_value(UInt8, arg.to_u8)",
      },
      Array(UInt16) => {
        type:                "array",
        default:             [] of UInt16,
        convert_arg_process: "add_array_value(UInt16, arg.to_u16)",
      },
      Array(UInt32) => {
        type:                "array",
        default:             [] of UInt32,
        convert_arg_process: "add_array_value(UInt32, arg.to_u32)",
      },
      Array(UInt64) => {
        type:                "array",
        default:             [] of UInt64,
        convert_arg_process: "add_array_value(UInt64, arg.to_u64)",
      },
      Array(Float32) => {
        type:                "array",
        default:             [] of Float32,
        convert_arg_process: "add_array_value(Float32, arg.to_f32)",
      },
      Array(Float64) => {
        type:                "array",
        default:             [] of Float64,
        convert_arg_process: "add_array_value(Float64, arg.to_f64)",
      },
      Array(String) => {
        type:                "array",
        default:             [] of String,
        convert_arg_process: "add_array_value(String, arg.to_s)",
      },
    }
  end
end
