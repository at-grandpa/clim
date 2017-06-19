require "./../spec_helper"

def create_values(
                  string : Hash(String, String) = {} of String => String,
                  bool : Hash(String, Bool) = {} of String => Bool,
                  array : Hash(String, Array(String)) = {} of String => Array(String))
  values = Options::Values.new
  values.string.merge!(string)
  values.bool.merge!(bool)
  values.array.merge!(array)
  values
end
