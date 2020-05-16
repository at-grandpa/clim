require "./../../../../../src/clim"

class MyCli < Clim
  main do
    run do |opts, args|
    end
    sub 1 do
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
