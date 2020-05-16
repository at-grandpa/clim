require "./../../../../../src/clim"

class MyCli < Clim
  main do
    desc 1
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
