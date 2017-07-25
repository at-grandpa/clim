# clim

"clim" is slim command line interface builder for Crystal.

*"clim" = "cli" + "slim"*

[![Build Status](https://travis-ci.org/at-grandpa/clim.svg?branch=master)](https://travis-ci.org/at-grandpa/clim)

## Goals

* Slim implementation.
* Intuitive code.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  clim:
    github: at-grandpa/clim
    version: 0.1.3
```

## Sample Code 1

```crystal
require "clim"

module Hello
  class Cli < Clim

    main_command
    desc "Hello CLI tool."
    usage "hello [options] [arguments] ..."
    array  "-n NAME",  "--name=NAME",      desc: "Target name.",        default: [] of String
    string "-g WORDS", "--greeting=WORDS", desc: "Words of greetings.", default: "Hello"
    run do |opts, args|
      print "#{opts["greeting"].as(String)}, "
      print "#{opts["name"].as(Array(String)).join(", ")}!"
      print "\n"
    end

  end
end

Hello::Cli.start(ARGV)
```

```
$ crystal build src/hello.cr
$ ./hello --help

  Hello CLI tool.

  Usage:

    hello [options] [arguments] ...

  Options:

    --help                           Show this help.
    -n NAME, --name=NAME             Target name.  [default:[] of String]
    -g WORDS, --greeting=WORDS       Words of greetings.  [default:Hello]

$ ./hello -n Taro -n Miko -g 'Good night'
Good night, Taro, Miko!
```

## Sample Code 2

```crystal
require "clim"

module FakeGit
  class Cli < Clim

    main_command
    desc  "Fake Git command."
    usage "fgit [sub_command] [arguments]"
    run do |opts, args|
      puts opts["help"]
    end

    sub do
      command "branch"
      desc  "List, create, or delete branches."
      usage "fgit branch [arguments]"
      run do |opts, args|
        puts "Fake Git branch!!"
      end

      command "log"
      desc  "Show commit logs."
      usage "fgit log [arguments]"
      run do |opts, args|
        puts "Fake Git log!!"
      end

      sub do
        command "short"
        desc  "Show commit short logs."
        usage "fgit log short [arguments]"
        run do |opts, args|
          puts "Fake Git short log!!"
        end

        command "long"
        desc  "Show commit long logs."
        usage "fgit log long [arguments]"
        run do |opts, args|
          puts "Fake Git long log!!"
        end
      end

    end

  end
end

FakeGit::Cli.start(ARGV)
```

```
$ crystal build -o ./fgit src/fake_git.cr
$ ./fgit

  Fake Git command.

  Usage:

    fgit [sub_command] [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    branch   List, create, or delete branches.
    log      Show commit logs.


$ ./fgit branch --help

  List, create, or delete branches.

  Usage:

    fgit branch [arguments]

  Options:

    --help                           Show this help.


$ ./fgit log --help

  Show commit logs.

  Usage:

    fgit log [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    short   Show commit short logs.
    long    Show commit long logs.


$ ./fgit log short --help

  Show commit short logs.

  Usage:

    fgit log short [arguments]

  Options:

    --help                           Show this help.


$ ./fgit log short
Fake Git short log!!
```


## Usage

### require

```crystal
require "clim"
```

### Command Informations

#### desc

```crystal
  desc  "My Command Line Interface."          # Command description.
```

#### usage

```crystal
  usage  "mycli [sub-command] [options] ..."  # Command usage.
```

### Command Options

#### string

```crystal
  string "-s ARG", "--string-long-name=ARG", desc: "Option description."  # String option
  run do |opts, args|
    puts opts["string-long-name"]                     # => print your option value.
    puts typeof(opts["string-long-name"])             # => (Array(String) | Bool | String | Nil)
    puts typeof(opts["string-long-name"].as(String))  # => String
  end
```

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

### default / required

```crystal
  string "-s ARG",  "--string-long-name=ARG", default: "default value"               # Default value.
  bool   "-b",      "--bool-long-name",       required: true                         # Required.
  array  "-a ITEM", "--array-long-name=ITEM", default: [] of String, required: true  # Both.
```

### help

```crystal
  run do |opts, args|
    puts opts["help"]  # Get help string.
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
