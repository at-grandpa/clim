require "./../../../../../src/clim"

class MyCli < Clim
  main do
    option "-a", "--opt-main-a", type: Bool
    option "--opt-main-b", type: Bool
    version "version 0.1", short: "-v"
    run do |opts, args|
    end
    sub "sub1" do
      option "-a", "--opt-sub1-a", type: Bool
      option "--opt-sub1-b", type: Bool
      alias_name "sub1_alias1", "sub1_alias2"
      help short: "-h"
      run do |opts, args|
      end
      sub "sub1_sub1" do
        option "-a", "--opt-sub1-sub1-a", type: Bool
        option "--opt-sub1-sub1-b", type: Bool
        run do |opts, args|
        end
      end
      sub "sub1_sub2" do
        option "-a", "--opt-sub1-sub2-a", type: Bool
        option "--opt-sub1-sub2-b", type: Bool
        alias_name "sub1_sub2_alias1", "sub1_sub2_alias2"
        run do |opts, args|
        end
        sub "sub1_sub2_sub1" do
          option "-a", "--opt-sub1-sub2-sub1-a", type: Bool
          option "--opt-sub1-sub2-sub1-b", type: Bool
          run do |opts, args|
          end
        end
        sub "sub1_sub2_sub2" do
          option "-a", "--opt-sub1-sub2-sub2-a", type: Bool
          option "--opt-sub1-sub2-sub2-b", type: Bool
          help short: "-p"
          run do |opts, args|
          end
        end
      end
    end
    sub "sub2" do
      option "-a", "--opt-sub2-a", type: Bool
      option "--opt-sub2-b", type: Bool
      alias_name "sub2_alias1", "sub2_alias2"
      run do |opts, args|
      end
      sub "sub2_sub1" do
        option "-a", "--opt-sub2-sub1-a", type: Bool
        option "--opt-sub2-sub1-b", type: Bool
        run do |opts, args|
        end
      end
    end
  end
end

MyCli.start(ARGV)
