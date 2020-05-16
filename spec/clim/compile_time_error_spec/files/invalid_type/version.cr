require "./../../../../../src/clim"

class MyCli < Clim
  main do
    version true
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
