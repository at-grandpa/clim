require "./../../spec_helper"

describe "STDOUT spec, " do
  it "display main help when main command with help_template." do
    `crystal run spec/clim/stdout_spec/files/main_with_help_template.cr --no-color -- --help`.should eq <<-DISPLAY

      command description: Command Line Interface Tool.
      command usage: main_of_clim_library [options] [arguments]

      options:
        --help                           Show this help.

      arguments:
        01. arg1      argument1 [type:String]
        02. arg2      argument2 [type:String]

      sub_commands:
        sub_command   sub_comand.


    DISPLAY
  end
  it "display sub_command help when main command with help_template." do
    `crystal run spec/clim/stdout_spec/files/main_with_help_template.cr --no-color -- sub_command --help`.should eq <<-DISPLAY

      command description: sub_comand.
      command usage: sub_command [options] [arguments]

      options:
        -n NUM                           Number. [type:Int32] [default:0]
        --help                           Show this help.

      arguments:
        01. sub-arg1      sub-argument1 [type:Bool]
        02. sub-arg2      sub-argument2 [type:Bool]

      sub_commands:
        sub_sub_command   sub_sub_comand description.


    DISPLAY
  end
  it "display sub_sub_command help when main command with help_template." do
    `crystal run spec/clim/stdout_spec/files/main_with_help_template.cr --no-color -- sub_command sub_sub_command --help`.should eq <<-DISPLAY

      command description: sub_sub_comand description.
      command usage: sub_sub_command [options] [arguments]

      options:
        -p PASSWORD                      Password. [type:String] [required]
        --help                           Show this help.

      arguments:
        01. sub-sub-arg1      sub sub argument1 [type:Int32]
        02. sub-sub-arg2      sub sub argument2 [type:Int32]

      sub_commands:



    DISPLAY
  end
  it "display main help when main command with help_template part2." do
    `crystal run spec/clim/stdout_spec/files/main_with_help_template2.cr --no-color -- --help`.should eq <<-DISPLAY
    usage: my_cli [--version] [--help] [-P PORT|--port=PORT]
                  [-h HOST|--host=HOST] [-p PASSWORD|--password=PASSWORD]

    Your original command line interface tool.

    options:
    -P PORT, --port=PORT
        Port number.
    -h HOST, --host=HOST
        Host name.
    -p PASSWORD, --password=PASSWORD
        Password.
    --help
        Show this help.
    --version
        Show version.

    arguments:
    01. arg1
        argument1
    02. arg2
        argument2

    sub commands:
        sub_command   my_cli's sub_comand.

    DISPLAY
  end
  it "display sub_command help when main command with help_template part2." do
    `crystal run spec/clim/stdout_spec/files/main_with_help_template2.cr --no-color -- sub_command --help`.should eq <<-DISPLAY
    usage: my_cli sub_command [--help] [-t|--tree]
                              [--html-path=PATH]

    my_cli's sub_comand.

    options:
    -t, --tree
        Tree.
    --html-path=PATH
        Html path.
    --help
        Show this help.

    arguments:
    01. sub-arg1
        sub-argument1
    02. sub-arg2
        sub-argument2

    DISPLAY
  end
  it "display main help." do
    `crystal run spec/clim/stdout_spec/files/main_default_help.cr --no-color -- sub_command --help`.should eq <<-DISPLAY

      sub_comand.

      Usage:

        sub_command [options] [arguments]

      Options:

        -n NUM                           Number. [type:Int32] [default:0]
        --help                           Show this help.

      Arguments:

        01. arg1      argument1 [type:Bool]

      Sub Commands:

        sub_sub_command   sub_sub_comand description.


    DISPLAY
  end
  it "display STDOUT of the run block execution. (main)" do
    `crystal run spec/clim/stdout_spec/files/run_block_execution.cr --no-color -- --option option_value argument_value unknown_value1 unknown_value2`.should eq <<-DISPLAY
    option       : option_value
    argument     : argument_value
    all_args     : ["argument_value", "unknown_value1", "unknown_value2"]
    unknown_args : ["unknown_value1", "unknown_value2"]
    argv         : ["--option", "option_value", "argument_value", "unknown_value1", "unknown_value2"]

    DISPLAY
  end
  it "display STDOUT of the run block execution. (sub_1)" do
    `crystal run spec/clim/stdout_spec/files/run_block_execution.cr --no-color -- sub_1 --option option_value argument_value unknown_value1 unknown_value2`.should eq <<-DISPLAY
    sub_1 option       : option_value
    sub_1 argument     : argument_value
    sub_1 all_args     : ["argument_value", "unknown_value1", "unknown_value2"]
    sub_1 unknown_args : ["unknown_value1", "unknown_value2"]
    sub_1 argv         : ["--option", "option_value", "argument_value", "unknown_value1", "unknown_value2"]

    DISPLAY
  end
  it "display STDOUT of the run block execution. (sub_sub_1)" do
    `crystal run spec/clim/stdout_spec/files/run_block_execution.cr --no-color -- sub_1 sub_sub_1 --option option_value argument_value unknown_value1 unknown_value2`.should eq <<-DISPLAY
    sub_sub_1 option       : option_value
    sub_sub_1 argument     : argument_value
    sub_sub_1 all_args     : ["argument_value", "unknown_value1", "unknown_value2"]
    sub_sub_1 unknown_args : ["unknown_value1", "unknown_value2"]
    sub_sub_1 argv         : ["--option", "option_value", "argument_value", "unknown_value1", "unknown_value2"]

    DISPLAY
  end
  it "display STDOUT of the run block execution. (sub-sub-2)" do
    `crystal run spec/clim/stdout_spec/files/run_block_execution.cr --no-color -- sub_1 sub-sub-2 --option option_value argument_value unknown_value1 unknown_value2`.should eq <<-DISPLAY
    sub-sub-2 option       : option_value
    sub-sub-2 argument     : argument_value
    sub-sub-2 all_args     : ["argument_value", "unknown_value1", "unknown_value2"]
    sub-sub-2 unknown_args : ["unknown_value1", "unknown_value2"]
    sub-sub-2 argv         : ["--option", "option_value", "argument_value", "unknown_value1", "unknown_value2"]

    DISPLAY
  end
  it "display STDOUT of the run block execution. (sub-2)" do
    `crystal run spec/clim/stdout_spec/files/run_block_execution.cr --no-color -- sub-2 --option option_value argument_value unknown_value1 unknown_value2`.should eq <<-DISPLAY
    sub-2 option       : option_value
    sub-2 argument     : argument_value
    sub-2 all_args     : ["argument_value", "unknown_value1", "unknown_value2"]
    sub-2 unknown_args : ["unknown_value1", "unknown_value2"]
    sub-2 argv         : ["--option", "option_value", "argument_value", "unknown_value1", "unknown_value2"]

    DISPLAY
  end
  it "exception message. (Required options)" do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- `.should eq <<-DISPLAY
    ERROR: Required options. "--prefix <text>"

    Please see the `--help`.

    DISPLAY
  end
  it "exception message. (Option that requires an argument)" do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix`.should eq <<-DISPLAY
    ERROR: Option that requires an argument. "--prefix"

    Please see the `--help`.

    DISPLAY
  end
  it "exception message. (Option that requires an argument)" do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo`.should eq <<-DISPLAY
    ERROR: Required arguments. "arg1"

    Please see the `--help`.

    DISPLAY
  end
  it "For --help, options and arguments are not required." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --help`.should eq <<-DISPLAY

      Command Line Interface Tool.
  
      Usage:
  
        hello <name>
  
      Options:
  
        --prefix <text>                  Prefix. [type:String] [required]
        -h, --help                       Show this help.
        -v, --version                    Show version.
  
      Arguments:
  
        01. arg1      argument1 [type:String] [required]


    DISPLAY
  end
  it "For -h, options and arguments are not required." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- -h`.should eq <<-DISPLAY

      Command Line Interface Tool.
  
      Usage:
  
        hello <name>
  
      Options:
  
        --prefix <text>                  Prefix. [type:String] [required]
        -h, --help                       Show this help.
        -v, --version                    Show version.
  
      Arguments:
  
        01. arg1      argument1 [type:String] [required]


    DISPLAY
  end
  it "If --help is specified along with options or arguments, a help message will be displayed." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo arg1 --help `.should eq <<-DISPLAY

      Command Line Interface Tool.
  
      Usage:
  
        hello <name>
  
      Options:
  
        --prefix <text>                  Prefix. [type:String] [required]
        -h, --help                       Show this help.
        -v, --version                    Show version.
  
      Arguments:
  
        01. arg1      argument1 [type:String] [required]


    DISPLAY
  end
  it "If -h is specified along with options or arguments, a help message will be displayed." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo arg1 -h `.should eq <<-DISPLAY

      Command Line Interface Tool.
  
      Usage:
  
        hello <name>
  
      Options:
  
        --prefix <text>                  Prefix. [type:String] [required]
        -h, --help                       Show this help.
        -v, --version                    Show version.
  
      Arguments:
  
        01. arg1      argument1 [type:String] [required]


    DISPLAY
  end
  it "For --version, options and arguments are not required." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --version`.should eq <<-DISPLAY
    Version 0.1.0

    DISPLAY
  end
  it "For -v, options and arguments are not required." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- -v`.should eq <<-DISPLAY
    Version 0.1.0

    DISPLAY
  end
  it "If --version is specified along with options or arguments, a version message will be displayed." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo arg1 --version `.should eq <<-DISPLAY
    Version 0.1.0

    DISPLAY
  end
  it "If -v is specified along with options or arguments, a version message will be displayed." do
    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo arg1 -v `.should eq <<-DISPLAY
    Version 0.1.0

    DISPLAY
  end
  it "For --bash-completion, options and arguments are not required." do
    expected_regex = <<-'DISPLAY'
    _.*\(\)
    \{
    \ \ \ \ local\ program\=\$\{COMP_WORDS\[0\]\}
    \ \ \ \ local\ cmd\=\$\{COMP_WORDS\[1\]\}
    \ \ \ \ local\ cur\="\$\{COMP_WORDS\[COMP_CWORD\]\}"
    \ \ \ \ local\ prev\="\$\{COMP_WORDS\[COMP_CWORD\-1\]\}"
    \ \ \ \ local\ cword\="\$\{COMP_CWORD\}"
    
    \ \ \ \ 
    if\ \[\[\ "\$\{prev\}"\ \=\=\ ".*"\ \]\]\ ;\ then
    \ \ \ \ COMPREPLY\=\(\ \$\(compgen\ \-W\ "\-v\ \-\-version\ \-\-prefix\ \-h\ \-\-help"\ \-\-\ \$\{cur\}\)\ \)
    else
    \ \ \ \ COMPREPLY\=\(\ \$\(compgen\ \-f\ \$\{cur\}\)\ \)
    fi
    
    
    \ \ \ \ return\ 0
    \}
    
    complete\ \-F\ _.* .*

    DISPLAY

    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --bash-completion`.should match(/#{expected_regex}/)
  end
  it "If --bash-completion is specified along with options or arguments, a bash completion string will be displayed." do
    expected_regex = <<-'DISPLAY'
    _.*\(\)
    \{
    \ \ \ \ local\ program\=\$\{COMP_WORDS\[0\]\}
    \ \ \ \ local\ cmd\=\$\{COMP_WORDS\[1\]\}
    \ \ \ \ local\ cur\="\$\{COMP_WORDS\[COMP_CWORD\]\}"
    \ \ \ \ local\ prev\="\$\{COMP_WORDS\[COMP_CWORD\-1\]\}"
    \ \ \ \ local\ cword\="\$\{COMP_CWORD\}"
    
    \ \ \ \ 
    if\ \[\[\ "\$\{prev\}"\ \=\=\ ".*"\ \]\]\ ;\ then
    \ \ \ \ COMPREPLY\=\(\ \$\(compgen\ \-W\ "\-v\ \-\-version\ \-\-prefix\ \-h\ \-\-help"\ \-\-\ \$\{cur\}\)\ \)
    else
    \ \ \ \ COMPREPLY\=\(\ \$\(compgen\ \-f\ \$\{cur\}\)\ \)
    fi
    
    
    \ \ \ \ return\ 0
    \}
    
    complete\ \-F\ _.* .*

    DISPLAY

    `crystal run spec/clim/stdout_spec/files/required.cr --no-color -- --prefix=foo arg1 --bash-completion`.should match(/#{expected_regex}/)
  end
end
