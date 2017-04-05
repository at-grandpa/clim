require "./../spec_helper"

describe Clim::Options do
  describe "#add" do
    it "raises an Exception when short option name is empty." do
      opts = Options.new
      expect_raises(Exception, "Empty short option.") do
        opts.add Option(String).new("", "", "", false, "", "")
      end
    end
    it "raises an Exception when short option name is duplicated." do
      opts = Options.new
      opts.add Option(String).new("-a", "--array", "", false, "", "")
      expect_raises(Exception, "Duplicate option. \"-a\"") do
        opts.add Option(String).new("-a", "--array", "", false, "", "")
      end
    end
    it "raises an Exception when long option name is duplicated." do
      opts = Options.new
      opts.add Option(String).new("-a", "--array", "", false, "", "")
      expect_raises(Exception, "Duplicate option. \"--array\"") do
        opts.add Option(String).new("-b", "--array", "", false, "", "")
      end
    end
    it "raises an Exception when long option name other than empty is duplicated." do
      opts = Options.new
      opts.add Option(String).new("-a", "", "", false, "", "")
      opts.add Option(String).new("-b", "", "", false, "", "")
      opts.add Option(String).new("-c", "--array", "", false, "", "")
      expect_raises(Exception, "Duplicate option. \"--array\"") do
        opts.add Option(String).new("-d", "--array", "", false, "", "")
      end
    end
  end
  describe Options::Values do
    describe "short name method." do
      describe "String" do
        it "defineded short name method and returns value same as long name method." do
          values = Options::Values.new
          values.string = {"key" => "value"}
          values.s.should eq(values.string)
        end
      end
      describe "Bool" do
        it "defineded short name method and returns value same as long name method." do
          values = Options::Values.new
          values.bool = {"key" => true}
          values.b.should eq(values.bool)
        end
      end
      describe "Array(String)" do
        it "defineded short name method and returns value same as long name method." do
          values = Options::Values.new
          values.array = {"key" => ["a", "b"]}
          values.a.should eq(values.array)
        end
      end
    end
    describe "#merge!" do
      describe "String" do
        it "merged only hash of String." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          values.merge!({"merge_string_key" => "merge string value"})

          values.string.should eq({
            "string_key"       => "string value",
            "merge_string_key" => "merge string value",
          })
          values.bool.should eq({"bool_key" => true})
          values.array.should eq({"array_key" => ["array", "value"]})
        end
        it "raises an Exception when option name of String is duplicated." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          expect_raises(Exception, "Duplicate string option. \"string_key\"") do
            values.merge!({"string_key" => "merge string value"}) # duplicated
          end
          values.merge!({"other_key" => false})      # not raises Exception
          values.merge!({"other_key" => ["a", "b"]}) # not raises Exception
        end
      end
      describe "Bool" do
        it "merged only hash of Bool." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          values.merge!({"merge_bool_key" => false})

          values.string.should eq({"string_key" => "string value"})
          values.bool.should eq({"bool_key" => true, "merge_bool_key" => false})
          values.array.should eq({"array_key" => ["array", "value"]})
        end
        it "raises an Exception when option name of Bool is duplicated." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          values.merge!({"other_key" => "merge string value"}) # not raises Exception
          expect_raises(Exception, "Duplicate bool option. \"bool_key\"") do
            values.merge!({"bool_key" => false}) # duplicated
          end
          values.merge!({"other_key" => ["a", "b"]}) # not raises Exception
        end
      end
      describe "Array(String)" do
        it "merged only hash of Array(String)." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          values.merge!({"merge_bool_key" => ["merge", "array", "value"]})

          values.string.should eq({"string_key" => "string value"})
          values.bool.should eq({"bool_key" => true})
          values.array.should eq({
            "array_key"      => ["array", "value"],
            "merge_bool_key" => ["merge", "array", "value"],
          })
        end
        it "raises an Exception when option name of Array(String )is duplicated." do
          values = Options::Values.new
          values.string = {"string_key" => "string value"}
          values.bool = {"bool_key" => true}
          values.array = {"array_key" => ["array", "value"]}

          values.merge!({"other_key" => "merge string value"}) # not raises Exception
          values.merge!({"other_key" => false})                # not raises Exception
          expect_raises(Exception, "Duplicate array option. \"array_key\"") do
            values.merge!({"array_key" => ["a", "b"]}) # duplicated
          end
        end
      end
    end
  end
  describe "#values" do
    it "returns hash when options are set." do
      opts = Options.new
      opts.add Option(String).new("-f", "--foo", "", false, "", "value foo")
      opts.add Option(String).new("-b", "--bar", "", false, "", "value bar")
      opts.add Option(String).new("-z VALUE", "--zoo=VALUE", "", false, "", "value zoo")
      opts.add Option(Bool).new("-v", "", false, false, "", true)
      opts.add Option(Array(String)).new("-a", "--array", [] of String, false, "", ["a", "b"])

      expect_values = Options::Values.new
      expect_values.merge!({"foo" => "value foo"})
      expect_values.merge!({"bar" => "value bar"})
      expect_values.merge!({"zoo" => "value zoo"})
      expect_values.merge!({"v" => true})
      expect_values.merge!({"array" => ["a", "b"]})

      opts.values.string.should eq(expect_values.string)
      opts.values.bool.should eq(expect_values.bool)
      opts.values.array.should eq(expect_values.array)
    end
  end
  describe "#exists_required!" do
    it "returns self when there is no required options." do
      opts = Options.new
      opt1 = Option(String).new("-a", "", "", false, "", "")
      opt1.set_string("foo")
      opts.add opt1
      opt2 = Option(String).new("-b", "", "", false, "", "")
      opt2.set_string("bar")
      opts.add opt2
      opts.exists_required!.should eq(nil)
    end
    it "raises an Exception when there is required option." do
      opts = Options.new
      opt1 = Option(String).new("-a", "", "", false, "", "")
      opt1.set_string("foo")
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
