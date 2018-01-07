require "./../spec_helper"

macro spec(spec_class_name, spec_dsl_lines, spec_desc, help_message, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}
    # define dsl
    class {{class_name}} < Clim
      main_command
      {% for spec_dsl_line, index in spec_dsl_lines %}
        {{spec_dsl_line.id}}
      {% end %}
      run do |opts, args|
        {% if spec_case.keys.includes?("expect_opts".id) %}
          opts["help"].should eq {{help_message}}
          opts.delete("help")
          opts.should eq Clim::ReturnOptsType.new.merge({{spec_case["expect_opts"]}})
          args.should eq {{spec_case["expect_args"]}}
        {% end %}
      end
    end

    # spec
    describe {{spec_desc}} do
      describe "if dsl is [" + {{spec_dsl_lines.join(", ")}} + "]," do
        describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
          {% if spec_case.keys.includes?("expect_opts".id) %}
            it "opts and args are given as arguments of run block." do
              {{class_name}}.start_main({{spec_case["argv"]}})
            end
          {% elsif spec_case.keys.includes?("exception_message".id) %}
            it "raises an Exception." do
              expect_raises(Exception, {{spec_case["exception_message"]}}) do
                {{class_name}}.start_main({{spec_case["argv"]}})
              end
            end
          {% else %}
            it "display help." do
              io = IO::Memory.new
              {{class_name}}.start_main({{spec_case["argv"]}}, io)
              io.to_s.should eq {{help_message}}
            end
          {% end %}
        end
      end
    end
  {% end %}
end