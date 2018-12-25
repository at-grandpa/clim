require "./../../../../src/clim"

class MyCli < Clim
  main_command do
    help_template do |desc, usage, options, sub_commands|
      options_help_lines = options.map do |option|
        option[:names].join(", ") + "\n" + "    #{option[:desc]}"
      end
      base = <<-BASE_HELP
      #{usage}

      #{desc}

      options:
      #{options_help_lines.join("\n")}

      BASE_HELP

      sub = <<-SUB_COMMAND_HELP

      sub commands:
      #{sub_commands.map(&.[](:help_line)).join("\n")}
      SUB_COMMAND_HELP

      sub_commands.empty? ? base : base + sub
    end
    desc "Your original command line interface tool."
    usage <<-USAGE
    usage: my_cli [--version] [--help] [-P PORT|--port=PORT]
                  [-h HOST|--host=HOST] [-p PASSWORD|--password=PASSWORD]
    USAGE
    version "version 1.0.0"
    option "-P PORT", "--port=PORT", type: Int32, desc: "Port number.", default: 3306
    option "-h HOST", "--host=HOST", type: String, desc: "Host name.", default: "localhost"
    option "-p PASSWORD", "--password=PASSWORD", type: String, desc: "Password."
    run do |opts, args|
    end
    sub_command "sub_command" do
      desc "my_cli's sub_comand."
      usage <<-USAGE
      usage: my_cli sub_command [--help] [-t|--tree]
                                [--html-path=PATH]
      USAGE
      option "-t", "--tree", type: Bool, desc: "Tree."
      option "--html-path=PATH", type: String, desc: "Html path."
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
