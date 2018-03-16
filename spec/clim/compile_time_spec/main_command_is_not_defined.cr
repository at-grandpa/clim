require "./../../../src/clim"

class MyCli < Clim
  sub_command do
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
