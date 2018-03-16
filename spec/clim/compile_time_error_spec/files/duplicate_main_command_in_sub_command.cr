require "./../../../../src/clim"

class MyCli < Clim
  main_command do
    run do |opts, args|
    end
    main_command do
    end
  end
end

MyCli.start(ARGV)
