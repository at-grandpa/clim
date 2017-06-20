require "./../spec_helper"

def create_values(
                  string : Hash(String, String | Nil) = {} of String => String | Nil,
                  bool : Hash(String, Bool | Nil) = {} of String => Bool | Nil,
                  array : Hash(String, Array(String) | Nil) = {} of String => Array(String) | Nil)
  values = Options::Values.new
  values.string.merge!(string)
  values.bool.merge!(bool)
  values.array.merge!(array)
  values
end
