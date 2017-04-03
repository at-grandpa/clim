require "./clim/exception"
require "./clim/option"
require "./clim/options"
require "./clim/command"
require "./clim/dsl"
require "./clim/*"
require "option_parser"

class Clim
  extend Dsl
end
