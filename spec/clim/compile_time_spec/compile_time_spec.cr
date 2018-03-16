require "./../../spec_helper"

describe "Compile time spec, " do
  it "Bool with 'required true'." do
    `crystal run spec/clim/compile_time_spec/bool_with_required_true.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_spec/bool_with_required_true.cr:6: You can not specify 'required: true' for Bool option.

        option "-b", type: Bool, desc: "your bool.", required: true
        ^


    ERROR
  end
  it "duplicate 'main_command'." do
    `crystal run spec/clim/compile_time_spec/duplicate_main_command.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_spec/duplicate_main_command.cr:9: Main command is already defined.

      main_command do
      ^~~~~~~~~~~~


    ERROR
  end
  it "duplicate 'main_command' in sub command." do
    `crystal run spec/clim/compile_time_spec/duplicate_main_command_in_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_spec/duplicate_main_command_in_sub_command.cr:7: Can not be declared 'main_command' as sub command.

        main_command do
        ^~~~~~~~~~~~


    ERROR
  end
  it "'main_command' is not defined." do
    `crystal run spec/clim/compile_time_spec/main_command_is_not_defined.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_spec/main_command_is_not_defined.cr:4: undefined local variable or method 'sub_command'

      sub_command do
      ^~~~~~~~~~~


    ERROR
  end
end
