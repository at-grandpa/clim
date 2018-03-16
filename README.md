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
- [x] `version` macro
- [x] Command name alias


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  clim:
    github: at-grandpa/clim
    version: 0.2.0
```

## Sample Code (main command)

*src/hello.cr*

```crystal
require "clim"

module Hello
  class Cli < Clim
    main_command do
      desc "Hello CLI tool."
      usage "hello [options] [arguments] ..."
      version "Version 0.1.0"
      option "-g WORDS", "--greeting=WORDS", type: String, desc: "Words of greetings.", default: "Hello"
      option "-n NAME", "--name=NAME", type: Array(String), desc: "Target name.", default: ["Taro"]
      run do |options, arguments|
        print "#{options.greeting}, "
        print "#{options.name.join(", ")}!"
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

## Sample Code (sub commands)

*src/fake-crystal-command.cr*

```crystal
require "clim"

module FakeCrystalCommand
  class Cli < Clim
    main_command do
      desc "Fake Crystal command."
      usage "fcrystal [sub_command] [arguments]"
      run do |options, arguments|
        puts options.help # => help string.
      end
      sub_command "tool" do
        desc "run a tool"
        usage "fcrystal tool [tool] [arguments]"
        run do |options, arguments|
          puts "Fake Crystal tool!!"
        end
        sub_command "format" do
          desc "format project, directories and/or files"
          usage "fcrystal tool format [options] [file or directory]"
          run do |options, arguments|
            puts "Fake Crystal tool format!!"
          end
        end
      end
      sub_command "spec" do
        desc "build and run specs"
        usage "crystal spec [options] [files]"
        run do |options, arguments|
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
  main_command do
    desc "My Command Line Interface."
    run do |options, arguments|
      # ...
    end
  end
end
```

#### usage

Usage of the command. It is displayed in Help.

```crystal
class MyCli < Clim
  main_command do
    usage  "mycli [sub-command] [options] ..."
    run do |options, arguments|
      # ...
    end
  end
end
```

#### alias_name

An alias for the command. It can be specified only for subcommand.

```crystal
class MyCli < Clim
  main_command do
    run do |options, arguments|
      # ...
    end
    sub_command "sub" do
      alias_name  "alias1", "alias2"
      run do |options, arguments|
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
  main_command do
    version "mycli version: 1.0.1"
    run do |options, arguments|
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
  main_command do
    version "mycli version: 1.0.1", short: "-v"
    run do |options, arguments|
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

 Argument | Description | example | required
---------|----------|---------|------
 First argument | short or long name | `-t TIMES`, `--times TIMES` | true
 Second　argument | long name | `--times TIMES` | false
 `type` | option type | `type: Array(Float32)` | true
 `desc` | option description | `desc: "option description."` | false
 `default` | default value | `default: [1.1_f32, 2.2_f32]` | false
 `required` | required flag | `required: true` | false

```crystal
class MyCli < Clim
  main_command do
    option "-g WORDS", "--greeting=WORDS", type: String, desc: "Words of greetings.", default: "Hello"
    option "-n NAME", "--name=NAME", type: Array(String), desc: "Target name.", default: ["Taro"]
    run do |options, arguments|
      puts typeof(options.greeting) # => String
      puts typeof(options.name)     # => Array(String)
    end
  end
end
```
デフォルトが指定されていなければ nilable になる
boolは引数いらない


#### bool

```crystal
  bool  "-b", "--bool-long-name", desc: "Option description."  # Bool option
  run do |opts, args|
    puts opts["bool-long-name"]                   # => print your option value.
    puts typeof(opts["bool-long-name"])           # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["bool-long-name"].as(Bool))  # => Bool
  end
```

#### array

```crystal
  array "-a ITEM", "--array-long-name=ITEM", desc: "Option description."  # Array option
  run do |opts, args|
    puts opts["array-long-name"]                            # => print your option value.
    puts typeof(opts["array-long-name"])                    # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["array-long-name"].as(Array(String)))  # => Array(String)
  end
```

### Option name

You can specify short name, long name or both.

see: [https://crystal-lang.org/api/OptionParser.html](https://crystal-lang.org/api/OptionParser.html)

#### Short name only

```crystal
  string "-s ARG", desc: "Option description." # String option
  run do |opts, args|
    puts opts["s"]                     # => print your option value.
    puts typeof(opts["s"])             # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["s"].as(String))  # => String
    # puts opts["string-long-name"]    # => ERROR: Missing hash key: "string-long-name"
  end
```

#### Long name only

```crystal
  string "--string-long-name=ARG", desc: "Option description." # String option
  run do |opts, args|
    puts opts["string-long-name"]                     # => print your option value.
    puts typeof(opts["string-long-name"])             # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["string-long-name"].as(String))  # => String
    # puts opts["s"]                                  # => ERROR: Missing hash key: "s"
  end
```


#### Both

If both are specified, the long name becomes the key.

```crystal
  string "-s ARG", "--string-long-name=ARG", desc: "Option description."  # String option
  run do |opts, args|
    puts opts["string-long-name"]                     # => print your option value.
    puts typeof(opts["string-long-name"])             # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["string-long-name"].as(String))  # => String
    # puts opts["s"]                                  # => ERROR: Missing hash key: "s"
  end
```

### default / required

```crystal
  string "-s ARG",  "--string-long-name=ARG", default: "default value"               # Default value.
  bool   "-b",      "--bool-long-name",       required: true                         # Required.
  array  "-a ITEM", "--array-long-name=ITEM", default: [] of String, required: true  # Both.
```

### help

```crystal
  run do |opts, args|
    puts opts["help"].as(String)  # Get help string.
  end
```

## Development

```
$ crystal spec
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/clim/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
