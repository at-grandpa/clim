require "./../spec_helper"

def create_values(other : Hash(String, String | Bool | Array(String) | Nil) = {} of String => String | Bool | Array(String) | Nil)
  values = Options::Values.new
  values.hash.merge!(other)
  values.hash
end
