require "../dsl_spec"

macro spec_for_sub(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main do
        version "version 1.0.0", short: "-v"
        argument "arg-1", type: String, default: "default argument"
        option "-a ARG", "--array=ARG", desc: "Option test.", type: Array(String), default: ["default string"]
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub "sub_1" do
          version "version 1.0.0", short: "-v"
          option "-a ARG", "--array=ARG", desc: "Option test.", type: Array(String), default: ["default string"]
          argument "arg-sub-1-1", type: String, default: "default value1"
          argument "arg-sub-1-2", type: String, default: "default value2"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub "sub_sub_1" do
            argument "arg-sub-sub-1", type: Bool, default: false
            option "-b", "--bool", type: Bool, desc: "Bool test."
            run do |opts, args|
              assert_opts_and_args({{spec_case}})
            end
          end
        end
        sub "sub_2" do
          argument "arg-sub-2", type: String, default: "foo"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
        end
      end
    end

    # spec
    describe "sub command case," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end
