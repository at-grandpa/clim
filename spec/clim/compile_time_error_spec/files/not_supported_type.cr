require "./../../../../src/clim"
require "big"

class MyCli < Clim
  main_command do
    option "-n", type: BigInt, desc: "my big int.", default: 0
    run do |opts, args|
      puts opts
      puts args
    end
  end
end

MyCli.start(ARGV)
