require "./../spec_helper"

def create_opts_hash(other : Hash(String, String | Bool | Array(String) | Nil) = {} of String => String | Bool | Array(String) | Nil)
  hash = Clim::ReturnOptsType.new
  hash.merge!(other)
  hash
end
