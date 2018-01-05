require "./../spec_helper"

describe Clim::Option do
  describe "#desc" do
    it "returns desc with default when default set." do
      opt = Option(String).new("", "", "default value", false, "description for spec.", "")
      opt.desc.should eq("description for spec.  [default:default value]")
    end
    it "returns appropriate desc when default is String type and empty." do
      opt = Option(String | Nil).new("", "", "", false, "description for spec.", "")
      opt.desc.should eq("description for spec.  [default:\"\"]")
    end
    it "returns appropriate desc when default is Bool type and false." do
      opt = Option(Bool | Nil).new("", "", false, false, "description for spec.", false)
      opt.desc.should eq("description for spec.  [default:false]")
    end
    it "returns appropriate desc when default is Array(String) type and empty." do
      opt = Option(Array(String) | Nil).new("", "", [] of String, false, "description for spec.", ["a", "b"])
      opt.desc.should eq("description for spec.  [default:[] of String]")
    end
    it "returns appropriate desc when default is nil." do
      opt = Option(String | Nil).new("", "", nil, false, "description for spec.", nil)
      opt.desc.should eq("description for spec.")
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
  describe "#set_string" do
    context "if type is String " do
      it "set value." do
        opt = Option(String).new("", "", "", false, "", "")
        opt.set_string("set value")
        opt.value.should eq("set value")
      end
    end
    context "if type is Bool " do
      it "set value." do
        opt = Option(Bool).new("", "", false, false, "", false)
        opt.set_bool("true")
        opt.value.should eq(true)
      end
    end
  end
  describe "#add_to_array" do
    it "set value." do
      opt = Option(Array(String)).new("", "", [] of String, false, "", [] of String)
      opt.add_to_array("set value")
      opt.value.should eq(["set value"])
    end
  end
end
