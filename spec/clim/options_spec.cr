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
  describe "#exists_required!" do
    it "returns self when there is no required options." do
      opts = Options.new
      opt1 = Option(String).new("-a", "", "", false, "", "")
      opt1.set_value = "foo"
      opts.add opt1
      opt2 = Option(String).new("-b", "", "", false, "", "")
      opt2.set_value = "bar"
      opts.add opt2
      opts.exists_required!.should eq(nil)
    end
    it "raises an Exception when there is required option." do
      opts = Options.new
      opt1 = Option(String).new("-a", "", "", false, "", "")
      opt1.set_value = "foo"
      opts.add opt1
      opt2 = Option(String).new("-b", "", "", true, "", "")
      opts.add opt2
      expect_raises(Exception, "Required options. \"-b\"") { opts.exists_required! }
    end
    it "raises an Exception when there are required options." do
      opts = Options.new
      opt1 = Option(String).new("-a", "", "", true, "", "")
      opts.add opt1
      opt2 = Option(String).new("-b", "", "", true, "", "")
      opts.add opt2
      expect_raises(Exception, "Required options. \"-a\", \"-b\"") { opts.exists_required! }
    end
  end
end
