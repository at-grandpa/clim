require "./spec_helper"

class IoCommand < Clim
  main do
    desc "main command."
    usage "main [sub_command] [arguments]"
    run do |opts, args, io|
      io.puts "Test"
    end
  end
end

describe Clim do
  describe "#start_parse" do
    context "with custom IO - memory" do
      io = IO::Memory.new
      IoCommand.start_parse([] of String, io: io)
      io.to_s.should eq "Test\n"
    end
  end
end
