require "./clim/option"
require "./clim/options"
require "./clim/command.cr"
require "./clim/dsl"
require "./clim/*"
require "option_parser"

class Clim
  extend Dsl
end
