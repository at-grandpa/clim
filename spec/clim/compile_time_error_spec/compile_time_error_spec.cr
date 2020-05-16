require "./../../spec_helper"

describe "Compile time spec, " do
  it "Bool with 'required true'." do
    `crystal run spec/clim/compile_time_error_spec/files/bool_with_required_true.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/bool_with_required_true.cr:6:3

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
  it "without run block in main_command." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_without_run_block.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'main_command'

    Code in macro 'main'

     1 | main_command do
         ^
    Called macro defined in src/clim.cr:12:3

     12 | macro main_command(&block)

    Which expanded to:

     > 1 | Clim::Command.command "main_command_of_clim_library" do
           ^
    Error: 'run' block is not defined.

    ERROR
  end
  it "without run block in sub_command." do
    `crystal run spec/clim/compile_time_error_spec/files/sub_command_without_run_block.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'sub_command'

    Code in macro 'sub'

     1 | sub_command("sub") do
         ^
    Called macro defined in src/clim/command.cr:155:5

     155 | macro sub_command(name, &block)

    Which expanded to:

     > 1 | command("sub") do
           ^
    Error: 'run' block is not defined.

    ERROR
  end
  it "without run block in sub_sub_command." do
    `crystal run spec/clim/compile_time_error_spec/files/sub_sub_command_without_run_block.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'sub_command'

    Code in macro 'sub'

     1 | sub_command("sub_sub") do
         ^
    Called macro defined in src/clim/command.cr:155:5

     155 | macro sub_command(name, &block)

    Which expanded to:

     > 1 | command("sub_sub") do
           ^
    Error: 'run' block is not defined.

    ERROR
  end
  it "without run block in sub_2_command." do
    `crystal run spec/clim/compile_time_error_spec/files/sub_2_command_without_run_block.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'sub_command'

    Code in macro 'sub'

     1 | sub_command("sub2") do
         ^
    Called macro defined in src/clim/command.cr:155:5

     155 | macro sub_command(name, &block)

    Which expanded to:

     > 1 | command("sub2") do
           ^
    Error: 'run' block is not defined.

    ERROR
  end
  it "duplicate 'sub_command'." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/duplicate_sub_command.cr:11:3

     11 | # Duplicate name.
        ^------
    Error: Command "sub_command" is already defined.

    ERROR
  end
  it "duplicate 'main_command' in sub command." do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/duplicate_main_command_in_sub_command.cr:7:3

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
  it "not supported option type." do
    `crystal run spec/clim/compile_time_error_spec/files/not_supported_option_type.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/not_supported_option_type.cr:6:5

     6 | option \"-n\", type: BigInt, desc: \"my big int.\", default: 0
         ^
    Error: Type [BigInt] is not supported on option.

    ERROR
  end
  it "not supported argument type." do
    `crystal run spec/clim/compile_time_error_spec/files/not_supported_argument_type.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/not_supported_argument_type.cr:6:5

     6 | argument "not", type: BigInt, desc: "my big int.", default: 0
         ^-------
    Error: Type [BigInt] is not supported on argument.

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
  it "empty argument name." do
    `crystal run spec/clim/compile_time_error_spec/files/empty_argument_name.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/empty_argument_name.cr:6:5

     6 | argument "", type: String, desc: "empty option name."
         ^-------
    Error: Empty argument name.

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
  it "'help' directive does not have a 'short' argument." do
    `crystal run spec/clim/compile_time_error_spec/files/help_directive_does_not_have_a_short_argument_for_main.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    In spec/clim/compile_time_error_spec/files/help_directive_does_not_have_a_short_argument_for_main.cr:5:5

     5 | help
         ^---
    Error: The 'help' directive requires the 'short' argument. (ex 'help short: "-h"'

    ERROR
  end
  it "duplicate argument name. (main command)" do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_argument_name_main.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'argument'

    Code in spec/clim/compile_time_error_spec/files/duplicate_argument_name_main.cr:7:3

     7 | argument "foo" # duplicate
       ^
    Called macro defined in src/clim/command.cr:196:5

     196 | macro argument(name, type = String, desc = "Argument description.", default = nil, required = false)

    Which expanded to:

       1 |       \n   2 |       \n > 3 |       Arguments.define_arguments("foo", String, "Argument description.", nil, false)
                 ^
    Error: Argument "foo" is already defined.

    ERROR
  end
  it "duplicate argument name. (sub command)" do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'argument'

    Code in spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub.cr:12:3

     12 | argument "foo" # duplicate
      ^
    Called macro defined in src/clim/command.cr:196:5

     196 | macro argument(name, type = String, desc = "Argument description.", default = nil, required = false)

    Which expanded to:

       1 |       \n   2 |       \n > 3 |       Arguments.define_arguments("foo", String, "Argument description.", nil, false)
                 ^
    Error: Argument "foo" is already defined.

    ERROR
  end
  it "duplicate argument name. (sub sub command)" do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub_sub.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'argument'

    Code in spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub_sub.cr:17:3

     17 | argument "foo" # duplicate
    ^
    Called macro defined in src/clim/command.cr:196:5

     196 | macro argument(name, type = String, desc = "Argument description.", default = nil, required = false)

    Which expanded to:

       1 |       \n   2 |       \n > 3 |       Arguments.define_arguments("foo", String, "Argument description.", nil, false)
                 ^
    Error: Argument "foo" is already defined.

    ERROR
  end
  it "duplicate argument name. (sub 2 command)" do
    `crystal run spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub_2.cr --no-color 2>&1`.should eq <<-ERROR
    Showing last frame. Use --error-trace for full trace.

    There was a problem expanding macro 'argument'

    Code in spec/clim/compile_time_error_spec/files/duplicate_argument_name_sub_2.cr:24:3

     24 | argument "foo" # deplicate
      ^
    Called macro defined in src/clim/command.cr:196:5

     196 | macro argument(name, type = String, desc = "Argument description.", default = nil, required = false)

    Which expanded to:

       1 |       \n   2 |       \n > 3 |       Arguments.define_arguments("foo", String, "Argument description.", nil, false)
                 ^
    Error: Argument "foo" is already defined.

    ERROR
  end
end
