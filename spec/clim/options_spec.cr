require "./../spec_helper"

describe Clim::Options do
  describe "#to_h" do
    it "returns hash when options are set." do
      opts = Options.new
      opts.add Option(String | Nil).new("-f", "--foo", "", false, "", "value foo")
      opts.add Option(String | Nil).new("-b", "--bar", "", false, "", "value bar")
      opts.add Option(String | Nil).new("-z VALUE", "--zoo=VALUE", "", false, "", "value zoo")
      opts.add Option(Bool | Nil).new("-v", "", false, false, "", true)
      opts.add Option(Array(String) | Nil).new("-a", "--array", [] of String, false, "", ["a", "b"])
      expect = Clim::ReturnOptsType.new
      expect.merge!({"help" => ""})
      expect.merge!({"foo" => "value foo"})
      expect.merge!({"bar" => "value bar"})
      expect.merge!({"zoo" => "value zoo"})
      expect.merge!({"v" => true})
      expect.merge!({"array" => ["a", "b"]})
      opts.to_h.should eq(expect)
    end
  end
  describe "#validate!" do
    it "returns self when there is no required options." do
      opts = Options.new
      opt1 = Option(String | Nil).new("-a", "", "", false, "", "")
      opt1.set_string("foo")
      opts.add opt1
      opt2 = Option(String | Nil).new("-b", "", "", false, "", "")
      opt2.set_string("bar")
      opts.add opt2
      opts.validate!.should eq(nil)
    end
    it "raises an Exception when there is required option." do
      opts = Options.new
      opt1 = Option(String | Nil).new("-a", "", nil, false, "", nil)
      opt1.set_string("foo")
      opts.add opt1
      opt2 = Option(String | Nil).new("-b", "", nil, true, "", nil)
      opts.add opt2
      expect_raises(Exception, "Required options. \"-b\"") { opts.validate! }
    end
    it "raises an Exception when there are required options." do
      opts = Options.new
      opt1 = Option(String | Nil).new("-a", "", nil, true, "", nil)
      opts.add opt1
      opt2 = Option(String | Nil).new("-b", "", nil, true, "", nil)
      opts.add opt2
      expect_raises(Exception, "Required options. \"-a\", \"-b\"") { opts.validate! }
    end
  end
end
