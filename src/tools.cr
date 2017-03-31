require "./clim"

class Tools < Clim
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
    string "-e CODE", "--eval=CODE", default: "puts opts.help", desc: "Code to insert into the run block."
    array "-s NAME:DESC", "--string=NAME:DESC", default: [] of String, desc: "Add \"string\" option."
    array "-b NAME:DESC", "--bool=NAME:DESC", default: [] of String, desc: "Add \"bool\"   option."
    array "-a NAME:DESC", "--array=NAME:DESC", default: [] of String, desc: "Add \"array\"  option."
    run do |opts, args|
      Init.run(opts, args)
    end

    command "direct"
    desc "Directly build the crystal code."
    usage "clim direct [command-name] [options] ..."
    string "-o FILE", "--output=FILE", default: "/tmp/crystal.out", desc: "Output filename."
    string "-e CODE", "--eval=CODE", default: "puts \"Hello, world!!\"", desc: "Crystal code to evaluation."
    bool "-r", "--release", default: false, desc: "Compile in release mode."
    bool "-c", "--clim", default: false, desc: "Use clim library."
    array "-s NAME:DESC", "--string=NAME:DESC", default: [] of String, desc: "Add \"string\" option. (with \"-c\")"
    array "-b NAME:DESC", "--bool=NAME:DESC", default: [] of String, desc: "Add \"bool\"   option. (with \"-c\")"
    array "-a NAME:DESC", "--array=NAME:DESC", default: [] of String, desc: "Add \"array\"  option. (with \"-c\")"
    run do |opts, args|
      if opts.b["clim"]
        raise "Wrong number of arguments for 'clim direct command-name' (given #{args.size}, expected 1)" unless args.size == 1
        args[0] = args[0] + "_directly_build_tmp"
        Init.run(opts, args, silent: true)
        Direct.run_with_clim(opts, args)
      else
        Direct.run(opts, args)
      end
    end
  end
end

require "./tools/init"
require "./tools/direct"

Tools.start(ARGV)
