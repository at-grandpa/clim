require "./../../../../src/clim"

class MyCli < Clim
  main do
    run do |opts, args|
      puts "#{args.argv.join(", ")}!"
    end
  end
end

MyCli.start(ARGV)
