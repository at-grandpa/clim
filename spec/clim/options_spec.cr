require "./../spec_helper"

describe Clim::Options do
  describe "#values" do
    it "returns hash when options are set." do
      opts = Options.new
      opts.add Option(String).new("-f", "--foo", "", false, "", "value foo")
      opts.add Option(String).new("-b", "--bar", "", false, "", "value bar")
      opts.add Option(String).new("-z VALUE", "--zoo=VALUE", "", false, "", "value zoo")
      opts.add Option(Bool).new("-v", "", false, false, "", true)
      opts.add Option(Array(String)).new("-a", "--array", [] of String, false, "", ["a", "b"])

      expect_values = Options::Values.new
      expect_values.string.merge!({"foo" => "value foo"})
      expect_values.string.merge!({"bar" => "value bar"})
      expect_values.string.merge!({"zoo" => "value zoo"})
      expect_values.bool.merge!({"v" => true})
      expect_values.array.merge!({"array" => ["a", "b"]})

      opts.values.string.should eq(expect_values.string)
      opts.values.bool.should eq(expect_values.bool)
      opts.values.array.should eq(expect_values.array)
    end
  end
  describe "#extract_opt_name" do
    it "extract opt name." do
      opts = Options.new
      opts.extract_opt_name("-a").should eq("a")
      opts.extract_opt_name("-a VALUE").should eq("a")
      opts.extract_opt_name("-a=VALUE").should eq("a")
      opts.extract_opt_name("--array").should eq("array")
      opts.extract_opt_name("--array VALUE").should eq("array")
      opts.extract_opt_name("--array=VALUE").should eq("array")
      opts.extract_opt_name("--dry-run").should eq("dry-run")
      opts.extract_opt_name("--dry_run").should eq("dry_run")
    end
  end
end
