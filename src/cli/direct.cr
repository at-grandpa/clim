require "tempfile"

class Cli
  class Direct
    def self.run(opts, args)
      tempfile = Tempfile.open("direct_crystal_build") do |file|
        file.print(opts.s["eval"])
      end
      stats = opts.b["stats"] ? "-s" : ""
      release = opts.b["release"] ? "--release" : ""
      command = "crystal build #{tempfile.path} -o #{opts.s["output"]} #{release} #{stats}"
      puts command
      system(command)
      puts "Build complete. -> #{opts.s["output"]}"
      tempfile.delete
    end
  end
end
