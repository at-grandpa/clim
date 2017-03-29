require "./clim"

class Cli < Clim
  main_command
  desc "Clim command line interface tools."
  usage "clim [sub-command] [options] ..."
  run do |opts, args|
    puts opts.help
  end

  sub do
    command "init"
    desc "Creates CLI tool skeleton."
    usage "clim init command-name [options] ..."
    array "-s NAME:DESC", "--string=NAME:DESC", default: [] of String, desc: "Add \"string\" option."
    array "-b NAME:DESC", "--bool=NAME:DESC", default: [] of String, desc: "Add \"bool\" option."
    array "-a NAME:DESC", "--array=NAME:DESC", default: [] of String, desc: "Add \"array\" option."
    run do |opts, args|
      Init.run(opts, args)
    end

    command "direct"
    desc "Direct build crystal code."
    usage "clim direct [options] ..."
    string "-o FILE", "--output=FILE", default: "/tmp/crystal.out", desc: "Output filename."
    string "-e CODE", "--eval=CODE", default: "puts \"Hello, world!!\"", desc: "Crystal code to evaluation."
    bool "-s", "--stats", default: false, desc: "Enable statistics output."
    bool "-r", "--release", default: false, desc: "Compile in release mode."
    run do |opts, args|
      Direct.run(opts, args)
    end
  end
end

require "./cli/init"
require "./cli/direct"

Cli.start(ARGV)
