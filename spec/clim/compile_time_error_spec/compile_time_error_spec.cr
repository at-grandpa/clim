require "./../../spec_helper"

describe "Compile time spec, " do
  it "Bool with 'required true'." do
    `crystal run spec/clim/compile_time_error_spec/files/bool_with_required_true.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/bool_with_required_true.cr:6:5

     6 | option \"-b\", type: Bool, desc: \"your bool.\", required: true
         ^
    Error: You can not specify 'required: true' for Bool option.

    ERROR
  end
  it "duplicate 'main_command'." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_main_command.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/duplicate_main_command.cr:9:3

     9 | main_command do
         ^-----------
    Error: Main command is already defined.

    ERROR
  end
  it "duplicate 'sub_command'." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr:12:5

     12 | command \"sub_command\" do
          ^------
    Error: Command \"sub_command\" is already defined.

    ERROR
  end
  it "duplicate 'main_command' in sub command." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr:7:5

     7 | main_command do
         ^-----------
    Error: Can not be declared 'main_command' or 'main' as sub command.

    ERROR
  end
  it "'main_command' is not defined." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_is_not_defined.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/main_command_is_not_defined.cr:4:3

     4 | sub_command do
         ^----------
    Error: undefined local variable or method 'sub_command' for MyCli.class

    ERROR
  end
  it "'main_command' with alias name." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_with_alias_name.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/main_command_with_alias_name.cr:5:5

     5 | alias_name \"main2\"
         ^---------
    Error: 'alias_name' is not supported on main command.

    ERROR
  end
  it "not supported type." do
    `crystal run spec/clim/compile_time_error_spec/files/not_supported_type.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/not_supported_type.cr:6:5

     6 | option \"-n\", type: BigInt, desc: \"my big int.\", default: 0
         ^
    Error: Type [BigInt] is not supported on option.

    ERROR
  end
  it "empty option name." do
    `crystal run spec/clim/compile_time_error_spec/files/empty_option_name.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/empty_option_name.cr:6:5

     6 | option \"\", type: String, desc: \"empty option name.\"
         ^
    Error: Empty option name.

    ERROR
  end
  it "help_template in sub_command." do
    `crystal run spec/clim/compile_time_error_spec/files/sub_command_with_help_template.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/sub_command_with_help_template.cr:8:7

     8 | help_template do |desc, usage, options, sub_commands|
         ^------------
    Error: Can not be declared 'help_template' as sub command.

    ERROR
  end
end
