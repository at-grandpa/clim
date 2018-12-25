# clim

"clim" is slim command line interface builder for Crystal.

_"clim" = "cli" + "slim"_

[![Build Status](https://travis-ci.org/at-grandpa/clim.svg?branch=master)](https://travis-ci.org/at-grandpa/clim)

## Goals

* Slim implementation.
* Intuitive code.

## Support

- [x] Option types
  - [x] `Int8`
  - [x] `Int16`
  - [x] `Int32`
  - [x] `Int64`
  - [x] `UInt8`
  - [x] `UInt16`
  - [x] `UInt32`
  - [x] `UInt64`
  - [x] `Float32`
  - [x] `Float64`
  - [x] `String`
  - [x] `Bool`
  - [x] `Array(Int8)`
  - [x] `Array(Int16)`
  - [x] `Array(Int32)`
  - [x] `Array(Int64)`
  - [x] `Array(UInt8)`
  - [x] `Array(UInt16)`
  - [x] `Array(UInt32)`
  - [x] `Array(UInt64)`
  - [x] `Array(Float32)`
  - [x] `Array(Float64)`
  - [x] `Array(String)`
- [x] Default values for option
- [x] Required flag for option
- [x] Nested sub commands
- [x] `--help` option
- [x] Customizable help message
- [x] `version` macro
- [x] Command name alias


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  clim:
    github: at-grandpa/clim
    version: 0.5.0
```

## Minimum sample

*src/minimum.cr*

```crystal
require "clim"

class MyCli < Clim
  main do
    run do |opts, args|
      puts "#{args.join(", ")}!"
    end
  end
end

MyCli.start(ARGV)
```

```console
$ crystal build -o ./minimum src/minimum.cr
$ ./minimum foo bar baz
foo, bar, baz!
```

## Command information sample

*src/hello.cr*

```crystal
require "clim"

module Hello
  class Cli < Clim
    main do
      desc "Hello CLI tool."
      usage "hello [options] [arguments] ..."
      version "Version 0.1.0"
      option "-g WORDS", "--greeting=WORDS", type: String, desc: "Words of greetings.", default: "Hello"
      option "-n NAME", "--name=NAME", type: Array(String), desc: "Target name.", default: ["Taro"]
      run do |opts, args|
        print "#{opts.greeting}, "
        print "#{opts.name.join(", ")}!"
        print "\n"
      end
    end
  end
end

Hello::Cli.start(ARGV)
```

```console
$ crystal build src/hello.cr
$ ./hello --help

  Hello CLI tool.

  Usage:

    hello [options] [arguments] ...

  Options:

    -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:"Hello"]
    -n NAME, --name=NAME             Target name. [type:Array(String)] [default:["Taro"]]
    --help                           Show this help.
    --version                        Show version.

$ ./hello -n Ichiro -n Miko -g 'Good night'
Good night, Ichiro, Miko!
```

## Sub commands sample

*src/fake-crystal-command.cr*

```crystal
require "clim"

module FakeCrystalCommand
  class Cli < Clim
    main do
      desc "Fake Crystal command."
      usage "fcrystal [sub_command] [arguments]"
      run do |opts, args|
        puts opts.help # => help string.
      end
      sub "tool" do
        desc "run a tool"
        usage "fcrystal tool [tool] [arguments]"
        run do |opts, args|
          puts "Fake Crystal tool!!"
        end
        sub "format" do
          desc "format project, directories and/or files"
          usage "fcrystal tool format [options] [file or directory]"
          run do |opts, args|
            puts "Fake Crystal tool format!!"
          end
        end
      end
      sub "spec" do
        desc "build and run specs"
        usage "fcrystal spec [options] [files]"
        run do |opts, args|
          puts "Fake Crystal spec!!"
        end
      end
    end
  end
end

FakeCrystalCommand::Cli.start(ARGV)
```

Build and run.

```console
$ crystal build -o ./fcrystal src/fake-crystal-command.cr
$ ./fcrystal

  Fake Crystal command.

  Usage:

    fcrystal [sub_command] [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    tool   run a tool
    spec   build and run specs

```

Show sub command help.

```console
$ ./fcrystal tool --help

  run a tool

  Usage:

    fcrystal tool [tool] [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    format   format project, directories and/or files

```

Run sub sub command.

```console
$ ./fcrystal tool format
Fake Crystal tool format!!
```

## Usage

### require & inherit

```crystal
require "clim"

class MyCli < Clim

  # ...

end
```

### Command Informations

#### desc

Description of the command. It is displayed in Help.

```crystal
class MyCli < Clim
  main do
    desc "My Command Line Interface."
    run do |opts, args|
      # ...
    end
  end
end
```

#### usage

Usage of the command. It is displayed in Help.

```crystal
class MyCli < Clim
  main do
    usage  "mycli [sub-command] [options] ..."
    run do |opts, args|
      # ...
    end
  end
end
```

#### alias_name

An alias for the command. It can be specified only for subcommand.

```crystal
class MyCli < Clim
  main do
    run do |opts, args|
      # ...
    end
    sub "sub" do
      alias_name  "alias1", "alias2"
      run do |opts, args|
        puts "sub_command run!!"
      end
    end
  end
end
```

```console
$ ./mycli sub
sub_command run!!
$ ./mycli alias1
sub_command run!!
$ ./mycli alias2
sub_command run!!
```

#### version

You can specify the string to be displayed with `--version`.

```crystal
class MyCli < Clim
  main do
    version "mycli version: 1.0.1"
    run do |opts, args|
      # ...
    end
  end
end
```

```console
$ ./mycli --version
mycli version: 1.0.1
```

If you want to display it even with `-v`, add ` short: "-v" `.

```crystal
class MyCli < Clim
  main do
    version "mycli version: 1.0.1", short: "-v"
    run do |opts, args|
      # ...
    end
  end
end
```

```console
$ ./mycli --version
mycli version: 1.0.1
$ ./mycli -v
mycli version: 1.0.1
```

#### option

You can specify multiple options for the command.

 Argument | Description | Example | Required | Default
---------|----------|---------|------|------
 First argument | short or long name | `-t TIMES`, `--times TIMES` | true | -
 Second argument | long name | `--times TIMES` | false | -
 `type` | option type | `type: Array(Float32)` | false | `String`
 `desc` | option description | `desc: "option description."` | false | `"Option description."`
 `default` | default value | `default: [1.1_f32, 2.2_f32]` | false | `nil`
 `required` | required flag | `required: true` | false | `false`

```crystal
class MyCli < Clim
  main do
    option "--greeting=WORDS", desc: "Words of greetings.", default: "Hello"
    option "-n NAME", "--name=NAME", type: Array(String), desc: "Target name.", default: ["Taro"]
    run do |opts, args|
      puts typeof(opts.greeting) # => String
      puts typeof(opts.name)     # => Array(String)
    end
  end
end
```

The type of the option is determined by the `default` and `required` patterns.

*Number*

For example `Int8`.

 `default` | `required` | Type
---------|----------|---------
 exist | `true` | `Int8` (default: Your specified value.) |
 exist | `false` | `Int8` (default: Your specified value.) |
 not exist | `true` | `Int8` |
 not exist | `false` | `Int8 \| Nil` |

*String*

 `default` | `required` | Type
---------|----------|---------
 exist | `true` | `String` (default: Your specified value.) |
 exist | `false` | `String` (default: Your specified value.) |
 not exist | `true` | `String` |
 not exist | `false` | `String \| Nil` |

*Bool*

 `default` | `required` | Type
---------|----------|---------
 exist | `true` | `Bool` (default: Your specified value.) |
 exist | `false` | `Bool` (default: Your specified value.) |
 not exist | `true` | `Bool` |
 not exist | `false` | `Bool` (default: `false`) |

*Array*

 `default` | `required` | Type
---------|----------|---------
 exist | `true` | `Array(T)` (default: Your specified value.) |
 exist | `false` | `Array(T)` (default: Your specified value.) |
 not exist | `true` | `Array(T)` |
 not exist | `false` | `Array(T)` (default: `[] of T`) |

For Bool, you do not need to specify arguments for short or long.

```crystal
class MyCli < Clim
  main do
    option "-v", "--verbose", type: Bool, desc: "Verbose."
    run do |opts, args|
      puts typeof(opts.verbose) # => Bool
    end
  end
end
```

Option method names are long name if there is a long, and short name if there is only a short. Also, hyphens are replaced by underscores.

```crystal
class MyCli < Clim
  main do
    option "-n", type: String, desc: "name."  # => short name only.
    option "--my-age", type: Int32, desc: "age." # => long name only.
    run do |opts, args|
      puts typeof(opts.n)      # => (String | Nil)
      puts typeof(opts.my_age) # => (Int32 | Nil)
    end
  end
end
```

### help_template

You can customize the help message. The `help_template` block needs to return `String`. Block arguments are `desc : String`, `usage : String`, `options : HelpOptionsType` and `sub_commands : HelpSubCommandsType`.

For example:

```crystal
class MyCli < Clim
  main do
    help_template do |desc, usage, options, sub_commands|
      options_help_lines = options.map do |option|
        option[:names].join(", ") + "\n" + "    #{option[:desc]}"
      end
      base = <<-BASE_HELP
      #{usage}

      #{desc}

      options:
      #{options_help_lines.join("\n")}

      BASE_HELP

      sub = <<-SUB_COMMAND_HELP

      sub commands:
      #{sub_commands.map(&.[](:help_line)).join("\n")}
      SUB_COMMAND_HELP

      sub_commands.empty? ? base : base + sub
    end
    desc "Your original command line interface tool."
    usage <<-USAGE
    usage: my_cli [--version] [--help] [-P PORT|--port=PORT]
                  [-h HOST|--host=HOST] [-p PASSWORD|--password=PASSWORD]
    USAGE
    version "version 1.0.0"
    option "-P PORT", "--port=PORT", type: Int32, desc: "Port number.", default: 3306
    option "-h HOST", "--host=HOST", type: String, desc: "Host name.", default: "localhost"
    option "-p PASSWORD", "--password=PASSWORD", type: String, desc: "Password."
    run do |opts, args|
    end
    sub "sub_command" do
      desc "my_cli's sub_comand."
      usage <<-USAGE
      usage: my_cli sub_command [--help] [-t|--tree]
                                [--html-path=PATH]
      USAGE
      option "-t", "--tree", type: Bool, desc: "Tree."
      option "--html-path=PATH", type: String, desc: "Html path."
      run do |opts, args|
      end
    end
  end
end

MyCli.start(ARGV)
```

```console
$ crystal run src/help_template_test.cr -- --help
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

sub commands:
    sub_command   my_cli's sub_comand.

```

options:

```crystal
# `options` type
alias HelpOptionsType = Array(NamedTuple(
    names:     Array(String),
    type:      Int8.class | Int32.class | ... | String.class | Bool.clsss, # => Support Types
    desc:      String,
    default:   Int8 | Int32 | ... | String | Bool, # => Support Types,
    required:  Bool,
    help_line: String
))

# `options` example
[
  {
    names:     ["-g WORDS", "--greeting=WORDS"],
    type:      String,
    desc:      "Words of greetings.",
    default:   "Hello",
    required:  false,
    help_line: "    -g WORDS, --greeting=WORDS       Words of greetings. [type:String] [default:\"Hello\"]",
  },
  {
    names:     ["-n NAME"],
    type:      Array(String),
    desc:      "Target name.",
    default:   ["Taro"],
    required:  true,
    help_line: "    -n NAME                          Target name. [type:Array(String)] [default:[\"Taro\"]] [required]",
  },
  {
    names:     ["--help"],
    type:      Bool,
    desc:      "Show this help.",
    default:   false,
    required:  false,
    help_line: "    --help                           Show this help.",
  },
]
```

sub_commands:

```crystal
# `sub_commands` type
alias HelpSubCommandsType = Array(NamedTuple(
    names:     Array(String),
    desc:      String,
    help_line: String
))

# `sub_commands` example
[
  {
    names:     ["abc", "def", "ghi"],
    desc:      "abc command.",
    help_line: "    abc, def, ghi            abc command.",
  },
  {
    names:     ["abcdef", "ghijkl", "mnopqr"],
    desc:      "abcdef command.",
    help_line: "    abcdef, ghijkl, mnopqr   abcdef command.",
  },
]
```

### help string

```crystal
class MyCli < Clim
  main do
    run do |opts, args|
      opts.help_string # => help string
    end
  end
end
```

## Development

```
$ make spec
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/clim/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) - creator, maintainer
