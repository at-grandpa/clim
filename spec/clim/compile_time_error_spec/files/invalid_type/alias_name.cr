require "./../../../../../src/clim"

class MyCli < Clim
  main do
    run do |opts, args|
    end
    sub "sub" do
      alias_name true, "foo", 1, ["bar"], false
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
