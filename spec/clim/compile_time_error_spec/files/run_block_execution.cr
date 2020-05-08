require "./../../../../src/clim"

class MyCli < Clim
  main do
    option "-o ARG", "--option=ARG", type: String
    argument "arg", type: String
    run do |opts, args|
      puts "option       : #{opts.option}"
      puts "argument     : #{args.arg}"
      puts "argv         : #{args.argv}"
      puts "unknown_args : #{args.unknown_args}"
    end
    sub "sub_1" do
      option "-o ARG", "--option=ARG", type: String
      argument "arg", type: String
      run do |opts, args|
        puts "sub_1 option       : #{opts.option}"
        puts "sub_1 argument     : #{args.arg}"
        puts "sub_1 argv         : #{args.argv}"
        puts "sub_1 unknown_args : #{args.unknown_args}"
      end
      sub "sub_sub_1" do
        option "-o ARG", "--option=ARG", type: String
        argument "arg", type: String
        run do |opts, args|
          puts "sub_sub_1 option       : #{opts.option}"
          puts "sub_sub_1 argument     : #{args.arg}"
          puts "sub_sub_1 argv         : #{args.argv}"
          puts "sub_sub_1 unknown_args : #{args.unknown_args}"
        end
      end
    end
    sub "sub_2" do
      option "-o ARG", "--option=ARG", type: String
      argument "arg", type: String
      run do |opts, args|
        puts "sub_2 option       : #{opts.option}"
        puts "sub_2 argument     : #{args.arg}"
        puts "sub_2 argv         : #{args.argv}"
        puts "sub_2 unknown_args : #{args.unknown_args}"
      end
    end
  end
end

MyCli.start(ARGV)
