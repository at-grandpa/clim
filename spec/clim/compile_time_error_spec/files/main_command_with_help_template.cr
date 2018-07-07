require "./../../../../src/clim"

class MyCli < Clim
  help_template do |desc, usage, options_help, sub_commands_help|
    <<-MY_HELP

      command description: #{desc}
      command usage: #{usage}

      options:
    #{options_help}

      sub_commands:
    #{sub_commands_help}


    MY_HELP
  end
  main_command do
    run do |opts, args|
    end
    sub_command "sub_command" do
      desc "sub_comand."
      option "-n NUM", type: Int32, desc: "Number.", default: 0
      run do |opts, args|
      end
      sub_command "sub_sub_command" do
        desc "sub_sub_comand description."
        option "-p PASSWORD", type: String, desc: "Password.", required: true
        run do |opts, args|
        end
      end
    end
  end
end

MyCli.start(ARGV)
