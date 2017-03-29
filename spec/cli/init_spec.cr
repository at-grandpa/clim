require "./../spec_helper"

describe Cli::Init do
  describe "#valid_name?" do
    it "returns true if the name is valid." do
      Init.valid_name?("foo").should be_true
      Init.valid_name?("Foo").should be_true
      Init.valid_name?("fOO").should be_true
      Init.valid_name?("foo1").should be_true
      Init.valid_name?("foo-bar").should be_true
      Init.valid_name?("foo_bar").should be_true
    end
    it "returns false if the name is invalid." do
      Init.valid_name?("0foo").should be_false
      Init.valid_name?("-foo").should be_false
      Init.valid_name?("_foo").should be_false
      Init.valid_name?("foo:").should be_false
      Init.valid_name?("foo;").should be_false
    end
  end
  describe "#validate_opts" do
    it "no raises Exception when options are valid." do
      opts = {
        "string" => ["name1:desc1", "name2:desc2", "name2:desc2"],
        "bool"   => ["name1:desc1", "name2:desc2", "name2:desc2"],
        "array"  => ["name1:desc1", "name2:desc2", "name2:desc2"],
      }
      Init.validate_opts(opts)
      (true).should eq(true)
    end
    it "raises Exception when option's value is not Array(String)." do
      opts = {
        "string" => "invalid_type:string",
      }
      expect_raises(Exception, "Invalid type option value. must be Array(String).") { Init.validate_opts(opts) }
    end
    it "raises Exception when option's value is invalid format." do
      opts = {
        "string" => ["invalid_format"],
      }
      expect_raises(Exception, "Invalid option format. Please use the following format. \"NAME:DESC\"") { Init.validate_opts(opts) }
    end
  end
  describe "#valid_opts_format" do
    it "returns true if the value is valid." do
      Init.valid_opts_format?("foo:bar").should be_true
      Init.valid_opts_format?("Foo:Bar").should be_true
      Init.valid_opts_format?("fOO:bAR").should be_true
      Init.valid_opts_format?("foo1:bar1").should be_true
      Init.valid_opts_format?("foo-foo:bar-bar").should be_true
      Init.valid_opts_format?("foo_foo:bar_bar").should be_true
      Init.valid_opts_format?("foo:bar baz").should be_true
      Init.valid_opts_format?("foo:bar baz.").should be_true
      Init.valid_opts_format?("foo:'bar'").should be_true
      Init.valid_opts_format?("foo:'bar baz'").should be_true
      Init.valid_opts_format?("foo::bar").should be_true
      Init.valid_opts_format?("foo:b'ar'").should be_true
      Init.valid_opts_format?("foo:あいう").should be_true
    end
    it "returns false if the value is invalid." do
      Init.valid_opts_format?("0foo:bar").should be_false
      Init.valid_opts_format?("-foo:bar").should be_false
      Init.valid_opts_format?("_foo:bar").should be_false
      Init.valid_opts_format?("あいう:bar").should be_false
    end
  end
  describe "#convert_to_code" do
    it "returns codes if the opts is valid." do
      opts = {
        "string" => ["string:string_desc"],
        "bool"   => ["bool:bool_desc"],
        "array"  => ["array:array_desc"],
      }
      codes = Init.convert_to_code(opts)
      codes.should eq(
        [
          "string \"-s VALUE\", \"--string=VALUE\", desc: \"string_desc\"",
          "bool \"-b\", \"--bool\", desc: \"bool_desc\"",
          "array \"-a VALUE\", \"--array=VALUE\", desc: \"array_desc\"",
        ]
      )
    end
    it "skip invalid opt_name." do
      opts = {
        "string"      => ["string:string_desc"],
        "bool"        => ["bool:bool_desc"],
        "array"       => ["array:array_desc"],
        "invalid_key" => ["invalid:invalid_desc"],
      }
      codes = Init.convert_to_code(opts)
      codes.should eq(
        [
          "string \"-s VALUE\", \"--string=VALUE\", desc: \"string_desc\"",
          "bool \"-b\", \"--bool\", desc: \"bool_desc\"",
          "array \"-a VALUE\", \"--array=VALUE\", desc: \"array_desc\"",
        ]
      )
    end
    it "raises Exception when option's value is not Array(String)." do
      opts = {
        "string" => "invalid_type:string",
      }
      expect_raises(Exception, "Invalid type option value. must be Array(String).") { Init.convert_to_code(opts) }
    end
    it "raises Exception if short opt_name is duplicated." do
      opts = {
        "string" => ["string1:string_desc", "string2:string_desc"],
      }
      expect_raises(Exception, "Short name \"s\" is duplicated. Please specified other option name.") { Init.convert_to_code(opts) }
    end
  end
end
