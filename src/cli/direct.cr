require "tempfile"
require "file_utils"
require "./path"

class Cli
  class Direct
    def self.run(opts, args)
      tempfile = Tempfile.open("direct_crystal_build") do |file|
        file.print(opts.s["eval"])
      end
      release = opts.b["release"] ? "--release" : ""
      command = "crystal build #{tempfile.path} -o #{opts.s["output"]} #{release}"
      system(command)
      raise "Failed to build." unless $?.success?
      puts "#{opts.s["output"]}"
    ensure
      tempfile.delete unless tempfile.nil?
    end

    def self.run_with_clim(opts, args)
      # Now in the current directory.
      command_name = args.first
      output_path = File.expand_path(opts.s["output"])

      # Go to the library directory.
      FileUtils.cd(FileUtils.pwd + "/" + command_name)
      system("crystal dep -q")
      raise "Failed to install libraries." unless $?.success?
      release = opts.b["release"] ? "--release" : ""
      command = "crystal build src/#{command_name}.cr -o #{output_path} #{release}"
      system(command)
      raise "Failed to build." unless $?.success?
      puts "#{opts.s["output"]}"
    end
  end
end
