require "./../../../../src/clim"

class MyCli < Clim
  main do
    desc "main command."
    run do |opts, args|
    end
    sub "sub" do
      desc "main command."
      option "--bash-completion", type: Bool, desc: "my --bash-completion option."
      run do |opts, args|
        puts "--bash-completion: #{opts.bash_completion}"
        puts "-----------help-------------"
        puts opts.help_string
      end
    end
  end
end

MyCli.start(ARGV)
