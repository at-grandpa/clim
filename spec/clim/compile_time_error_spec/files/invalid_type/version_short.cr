require "./../../../../../src/clim"

class MyCli < Clim
  main do
    version "foo", short: 1
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
