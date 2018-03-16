require "./../spec_helper"

macro assert_opts_and_args(spec_case)
    opts.help.should eq {{spec_case["expect_help"]}}
    {% if spec_case.keys.includes?("expect_opts".id) %}
      opts.{{spec_case["expect_opts"]["method"].id}}.is_a?({{spec_case["expect_opts"]["type"]}}).should be_true
      opts.{{spec_case["expect_opts"]["method"].id}}.should eq {{spec_case["expect_opts"]["expect_value"]}}
    {% end %}
    args.should eq {{spec_case["expect_args"]}}
end

macro expand_dsl_lines(lines)
  {% for line, index in lines %}
    {{line.id}}
  {% end %}
end

macro it_blocks(class_name, spec_case)
  {% if spec_case.keys.includes?("expect_args".id) %}
    it "opts and args are given as arguments of run block." do
      {{class_name}}.start({{spec_case["argv"]}})
    end
  {% elsif spec_case.keys.includes?("exception_message".id) %}
    it "raises an Exception." do
      expect_raises(Exception, {{spec_case["exception_message"]}}) do
        {{class_name}}.start({{spec_case["argv"]}})
      end
    end
  {% elsif spec_case.keys.includes?("expect_help".id) %}
    it "display help." do
      io = IO::Memory.new
      {{class_name}}.start({{spec_case["argv"]}}, io)
      io.to_s.should eq {{spec_case["expect_help"]}}
    end
  {% else %}
    it "output." do
      io = IO::Memory.new
      {{class_name}}.start({{spec_case["argv"]}}, io)
      io.to_s.should eq {{spec_case["expect_output"]}}
    end
  {% end %}
end

macro spec(spec_class_name, spec_dsl_lines, spec_desc, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        expand_dsl_lines({{spec_dsl_lines}})
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
      end
    end

    # spec
    describe {{spec_desc}} do
      describe "if dsl is [" + {{spec_dsl_lines.join(", ")}} + "]," do
        describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
          it_blocks({{class_name}}, {{spec_case}})
        end
      end
    end
  {% end %}
end
