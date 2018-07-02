require "./../../spec_helper"

describe "Compile time spec, " do
  it "Bool with 'required true'." do
    `crystal run spec/clim/compile_time_error_spec/files/bool_with_required_true.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/bool_with_required_true.cr:6: You can not specify 'required: true' for Bool option.

        option "-b", type: Bool, desc: "your bool.", required: true
        ^


    ERROR
  end
  it "duplicate 'main_command'." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_main_command.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/duplicate_main_command.cr:9: Main command is already defined.

      main_command do
      ^~~~~~~~~~~~


    ERROR
  end
  it "duplicate 'sub_command'." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr:12: Command "sub_command" is already defined.

        command "sub_command" do
        ^~~~~~~


    ERROR
  end
  it "duplicate 'main_command' in sub command." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr:7: Can not be declared 'main_command' as sub command.

        main_command do
        ^~~~~~~~~~~~


    ERROR
  end
  it "'main_command' is not defined." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_is_not_defined.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/main_command_is_not_defined.cr:4: undefined local variable or method 'sub_command'

      sub_command do
      ^~~~~~~~~~~


    ERROR
  end
  it "'main_command' with alias name." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_with_alias_name.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/main_command_with_alias_name.cr:5: 'alias_name' is not supported on main command.

        alias_name "main2"
        ^~~~~~~~~~


    ERROR
  end
  it "not supported type." do
    `crystal run spec/clim/compile_time_error_spec/files/not_supported_type.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/not_supported_type.cr:6: Type [BigInt] is not supported on option.

        option "-n", type: BigInt, desc: "my big int.", default: 0
        ^


    ERROR
  end
  it "empty option name." do
    `crystal run spec/clim/compile_time_error_spec/files/empty_option_name.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/empty_option_name.cr:6: Empty option name.

        option "", type: String, desc: "empty option name."
        ^


    ERROR
  end
  it "sub command with custom_help." do
    `crystal run spec/clim/compile_time_error_spec/files/sub_command_with_custom_help.cr --no-color 2>&1`.should eq <<-ERROR
    Error in spec/clim/compile_time_error_spec/files/sub_command_with_custom_help.cr:8: Can not be declared 'custom_help' as sub command.

          custom_help do |desc, usage, options_help, sub_commands|
          ^~~~~~~~~~~


    ERROR
  end
  it "display sub_command help when main command with custom_help." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_with_custom_help.cr --no-color -- sub_command --help`.should eq <<-DISPLAY

      command description: sub_comand.
      command usage: sub_command [options] [arguments]

      options:
        -n NUM                           Number. [type:Int32] [default:0]
        --help                           Show this help.

      sub_commands:
        sub_sub_command   sub_sub_comand description.


    DISPLAY
  end
end
