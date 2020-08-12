require "./../../../../src/clim"

class MyCli < Clim
  main do
    desc "main command."
    option "-b", "--bash-completion", type: Bool, desc: "my --bash-completion option."
    run do |opts, args|
    end
  end
end

MyCli.start(ARGV)
