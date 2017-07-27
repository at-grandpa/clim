require "./clim"

module Hello
  class Cli < Clim
    main_command do
      desc "Hello CLI tool."
      usage "hello [options] [arguments] ..."
      array "-n NAME", "--name=NAME", desc: "Target name.", default: [] of String
      string "-g WORDS", "--greeting=WORDS", desc: "Words of greetings.", default: "Hello"
      bool "-w", "--web", desc: "Web flag."
      run do |opts, args|
        p "main"
        p typeof(opts)
        # p typeof(opts.name)
        # p typeof(opts.greeting)
        # p typeof(opts.web?)
        # p opts.name
        # p opts.greeting
        # p opts.web?
      end
    end

    sub do
      command(name: "ttt") do
        desc "Ttt tool."
        usage "hello ttt [options] [arguments] ..."
        array "-b BANANA", "--banana=BANANA", desc: "Banana name.", default: [] of String
        string "-a APPLE", "--apple=APPLE", desc: "Apple.", default: "Hello"
        bool "-o", "--orange", desc: "Orange."
        run do |opts, args|
          p "ttt"
          p typeof(opts)
          # p typeof(opts.banana)
          # p typeof(opts.apple)
          # p typeof(opts.orange?)
          # p opts.banana
          # p opts.apple
          # p opts.orange?
        end
      end
    end
  end
end

Hello::Cli.start(ARGV)
