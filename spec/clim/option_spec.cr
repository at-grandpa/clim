require "./../spec_helper"

describe Clim::Option do
  describe "#desc" do
    it "returns desc with default when default set." do
      opt = Option(String).new("", "", "default value", false, "description for spec.", "")
      opt.desc.should eq("description for spec.  [default:default value]")
    end
    it "returns desc with default and required when default set and required is true." do
      opt = Option(String).new("", "", "default value", true, "description for spec.", "")
      opt.desc.should eq("description for spec.  [default:default value]  [required]")
    end
  end
  describe "#name" do
    it "returns opt name when long name exests." do
      opt = Option(String).new("-l", "--long-name", "", false, "", "")
      opt.name.should eq("long-name")
    end
    it "returns opt name when long name does not exests." do
      opt = Option(String).new("-l", "", "", false, "", "")
      opt.name.should eq("l")
    end
  end
  describe "#extract_name" do
    it "extract opt name." do
      opt = Option(String).new("", "", "", false, "", "")
      opt.extract_name("-a").should eq("a")
      opt.extract_name("-a VALUE").should eq("a")
      opt.extract_name("-a=VALUE").should eq("a")
      opt.extract_name("--array").should eq("array")
      opt.extract_name("--array VALUE").should eq("array")
      opt.extract_name("--array=VALUE").should eq("array")
      opt.extract_name("--dry-run").should eq("dry-run")
      opt.extract_name("--dry_run").should eq("dry_run")
    end
  end
  describe "#to_h" do
    it "returns opt hash when type is String." do
      opt = Option(String).new("-l", "--long-name", "", false, "", "string_value")
      opt.to_h.should eq({"long-name" => "string_value"})
    end
    it "returns opt hash when type is Bool." do
      opt = Option(Bool).new("-l", "--long-name", false, false, "", true)
      opt.to_h.should eq({"long-name" => true})
    end
    it "returns opt hash when type is Array(String)." do
      opt = Option(Array(String)).new("-l", "--long-name", [] of String, false, "", ["a", "b"])
      opt.to_h.should eq({"long-name" => ["a", "b"]})
    end
  end
  describe "#set_value" do
    context "if type is String " do
      it "set exist and value." do
        opt = Option(String).new("", "", "", false, "", "")
        opt.set_value = "set value"
        opt.exist.should be_true
        opt.value.should eq("set value")
      end
    end
    context "if type is Bool " do
      it "set exist and value." do
        opt = Option(Bool).new("", "", false, false, "", false)
        opt.set_value = true
        opt.exist.should be_true
        opt.value.should eq(true)
      end
    end
  end
  describe "#add_value" do
    it "set exist and value." do
      opt = Option(Array(String)).new("", "", [] of String, false, "", [] of String)
      opt.add_value("set value")
      opt.exist.should be_true
      opt.value.should eq(["set value"])
    end
  end
end
