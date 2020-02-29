require "./../spec_helper"

macro assert_opts_and_args(spec_case)
    opts.help_string.should eq {{spec_case["expect_help"]}}
    {% if spec_case.keys.includes?("expect_opts".id) %}
      if opts.responds_to?(:{{spec_case["expect_opts"]["method"].id}})
        typeof(opts.{{spec_case["expect_opts"]["method"].id}}).should eq {{spec_case["expect_opts"]["type"]}}
        opts.{{spec_case["expect_opts"]["method"].id}}.should eq {{spec_case["expect_opts"]["expect_value"]}}
      else
        raise "undefined method '#{{{spec_case["expect_opts"]["method"].stringify}}}' for #{typeof(opts).to_s}."
      end
    {% end %}
    args.list.should eq {{spec_case["expect_args_value"]}}
    {% if spec_case.keys.includes?("expect_args".id) %}
      if args.responds_to?(:{{spec_case["expect_args"]["method"].id}})
        typeof(args.{{spec_case["expect_args"]["method"].id}}).should eq {{spec_case["expect_args"]["type"]}}
        args.{{spec_case["expect_args"]["method"].id}}.should eq {{spec_case["expect_args"]["expect_value"]}}
      end
    {% end %}
end

macro expand_lines(lines)
  {% for line, index in lines %}
    {{line.id}}
  {% end %}
end

macro it_blocks(class_name, spec_case)
  {% if spec_case.keys.includes?("expect_args_value".id) %}
    it "opts and args are given as arguments of run block." do
      {{class_name}}.start_parse({{spec_case["argv"]}})
    end
  {% elsif spec_case.keys.includes?("exception_message".id) %}
    it "raises an Exception." do
      expect_raises(Exception, {{spec_case["exception_message"]}}) do
        {{class_name}}.start_parse({{spec_case["argv"]}})
      end
    end
  {% elsif spec_case.keys.includes?("expect_help".id) %}
    it "display help." do
      io = IO::Memory.new
      {{class_name}}.start_parse({{spec_case["argv"]}}, io)
      io.to_s.should eq {{spec_case["expect_help"]}}
    end
  {% elsif spec_case.keys.includes?("expect_version".id) %}
    it "display version." do
      io = IO::Memory.new
      {{class_name}}.start_parse({{spec_case["argv"]}}, io)
      io.to_s.should eq {{spec_case["expect_version"]}}
    end
  {% else %}
    it "output." do
      io = IO::Memory.new
      {{class_name}}.start_parse({{spec_case["argv"]}}, io)
      io.to_s.should eq {{spec_case["expect_output"]}}
    end
  {% end %}
end

macro spec(spec_class_name, spec_desc, spec_cases, spec_dsl_lines = [] of StringLiteral, spec_class_define_lines = [] of StringLiteral, spec_sub_command_lines = [] of StringLiteral)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      expand_lines({{spec_class_define_lines}})
      main_command do
        expand_lines({{spec_dsl_lines}})
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        expand_lines({{spec_sub_command_lines}})
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
