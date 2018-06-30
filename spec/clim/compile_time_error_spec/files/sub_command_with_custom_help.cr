require "./../../../../src/clim"

class MyCli < Clim
  main_command do
    run do |opts, args|
    end
    sub_command "sub_command" do
      custom_help do |desc, usage, options_help|
        <<-MY_HELP
        command description: \#{desc}
        command usage: \#{usage}

        options:
        \#{options_help}
        MY_HELP
      end
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
