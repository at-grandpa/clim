require "./../../spec_helper"

describe "STDOUT spec, " do
  it "display sub_command help when main command with help_template." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_with_help_template.cr --no-color -- sub_command --help`.should eq <<-DISPLAY

      command description: sub_comand.
      command usage: sub_command [options] [arguments]

      options:
        -n NUM                           Number. [type:Int32] [default:0]
        --help                           Show this help.

      sub_commands:
        sub_sub_command   sub_sub_comand description.


    DISPLAY
  end
  it "display main_command help." do
    `crystal run spec/clim/compile_time_error_spec/files/main_command_default_help.cr --no-color -- sub_command --help`.should eq <<-DISPLAY

      sub_comand.

      Usage:

        sub_command [options] [arguments]

      Options:

        -n NUM                           Number. [type:Int32] [default:0]
        --help                           Show this help.

      Sub Commands:

        sub_sub_command   sub_sub_comand description.


    DISPLAY
  end
end
