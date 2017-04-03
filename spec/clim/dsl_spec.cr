require "./../spec_helper"

def create_values(
                  string = {} of String => String,
                  bool = {} of String => Bool,
                  array = {} of String => Array(String))
  values = Options::Values.new
  values.string = string
  values.bool = bool
  values.array = array
  values
end

