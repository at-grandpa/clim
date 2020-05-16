require "./../../../../../src/clim"

class MyCli < Clim
  main do
    usage true
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
