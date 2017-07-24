require "./clim"

module Hello
  class Cli < Clim
    main_command do
      desc "Hello CLI tool."
      usage "hello [options] [arguments] ..."
      array "-n NAME", "--name=NAME", desc: "Target name.", default: [] of String
      string "-g WORDS", "--greeting=WORDS", desc: "Words of greetings.", default: "Hello"
      run do |opts, args|
        puts "aaa"
      end
    end
  end
end

Hello::Cli.start(ARGV)
