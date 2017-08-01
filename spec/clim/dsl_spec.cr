require "./../spec_helper"

def create_values(other : Hash(String, String | Bool | Array(String) | Nil) = {} of String => String | Bool | Array(String) | Nil)
  values = Clim::ReturnOptsType.new
  values.merge!(other)
  values
end
