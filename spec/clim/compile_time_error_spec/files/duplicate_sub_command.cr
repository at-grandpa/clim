require "./../../../../src/clim"

class MyCli < Clim
  main_command do
    run do |opts, args|
    end
    command "sub_command" do
      run do |opts, args|
      end
    end
    # Duplicate name.
    command "sub_command" do
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
