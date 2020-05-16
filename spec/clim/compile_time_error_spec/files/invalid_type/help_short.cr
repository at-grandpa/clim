require "./../../../../../src/clim"

class MyCli < Clim
  main do
    help short: true
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
