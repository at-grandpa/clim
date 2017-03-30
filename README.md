# clim

"clim" is slim CLI builder and tools by Crystal.

*"clim" = "cli" + "slim"*

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  clim:
    github: at-grandpa/clim
```
## Sample Code

```crystal
require "clim"

module Hello
  class Cli < Clim

    main_command
    desc   "Hello CLI tool."
    usage  "hello [options] [arguments] ..."
    array  "-n NAME",  "--name=NAME",      desc: "Target name.",        default: [] of String
    string "-g WORDS", "--greeting=WORDS", desc: "Words of greetings.", default: "Hello"
    run do |opts, args|
      puts "#{opts.s["greeting"]},"
      puts "#{opts.a["name"].join(", ")}!"
    end

  end
end

Hello::Cli.start(ARGV)
```

```
$ crystal build src/hello.cr
$ ./hello -n Taro -n Miko -g 'Good night'
Good night,
Taro, Miko!
```

## DSL

```crystal
require "clim"

module Hello
  class Cli < Clim

    main_command
    #
    # Put main command options here.
    #
    run do |opts, args|
      # Put main command code here.
    end

    sub do
      command "sub_command"
      #
      # Put sub command options here.
      #
      run do |opts, args|
        # Put sub command code here.
      end

      sub do
        command "sub_sub_command"
        #
        # Put sub sub command options here.
        #
        run do |opts, args|
          # Put sub sub command code here.
        end

        # ...

      end
    end

  end
end

Hello::Cli.start(ARGV)
```

See also [src/cli.cr](https://github.com/at-grandpa/clim/blob/master/src/cli.cr)

## Usage

### require

```crystal
require "clim"
```

### Options

#### desc

```crystal
  desc  "My Command Line Interface."          # Command description.
```

#### usage

```crystal
  usage  "mycli [sub-command] [options] ..."  # Command usage.
```

#### string

```crystal
  string "-s ARG", "--string-long-name=ARG", desc: "Option description."  # String option
  run do |opts, args|
    puts opts.string["string-long-name"]  # Get value.
    puts opts.s["string-long-name"]       # Ditto.
  end
```

#### bool

```crystal
  bool  "-b", "--bool-long-name", desc: "Option description."  # Bool option
  run do |opts, args|
    puts opts.bool["bool-long-name"]  # Get value.
    puts opts.b["bool-long-name"]     # Ditto.
  end
```

#### array

```crystal
  array "-a ITEM", "--array-long-name=ITEM", desc: "Option description."  # Array option
  run do |opts, args|
    puts opts.array["array-long-name"]  # Get value.
    puts opts.a["array-long-name"]      # Ditto.
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
    puts opts.help      # Get help string.
  end
```

## Tools

Clim also has a cli tools.

### Build

```
$ crystal build src/cli.cr -o clim --release
$ ./clim

  Clim command line interface tools.

  Usage:

    clim [sub-command] [options] ...

  Options:

    -h, --help                       Show this help.

  Sub Commands:

    init     Creates CLI tool skeleton.
    direct   Directly build the crystal code.

```

### Sub commands

#### init

Creates CLI tool skeleton.

```
$ ./clim init -h

  Creates CLI tool skeleton.

  Usage:

    clim init command-name [options] ...

  Options:

    -h, --help                       Show this help.
    -e CODE, --eval=CODE             Code to insert into the run block.  [default:puts opts.help]
    -s NAME:DESC, --string=NAME:DESC Add "string" option.  [default:[]]
    -b NAME:DESC, --bool=NAME:DESC   Add "bool"   option.  [default:[]]
    -a NAME:DESC, --array=NAME:DESC  Add "array"  option.  [default:[]]

$ ./clim init hello -a name:'Target name.' -s greeting:'Words of greetings.' -e 'puts "#{opts.s["greeting"]},\n#{opts.a["name"].join(", ")}!"'

...

$ cd hello
$ crystal dep
$ crystal build src/hello.cr
$ ./hello -h

  Command Line Interface.

  Usage:

    hello [options] [arguments]

  Options:

    -h, --help                       Show this help.
    -g VALUE, --greeting=VALUE       Words of greetings.
    -n VALUE, --name=VALUE           Target name.  [default:[]]

```

#### direct

Directly build the crystal code.

```
$ ./clim direct -h

  Directly build the crystal code.

  Usage:

    clim direct [command-name] [options] ...

  Options:

    -h, --help                       Show this help.
    -o FILE, --output=FILE           Output filename.  [default:/tmp/crystal.out]
    -e CODE, --eval=CODE             Crystal code to evaluation.  [default:puts "Hello, world!!"]
    -r, --release                    Compile in release mode.  [default:false]
    -c, --clim                       Use clim library.  [default:false]
    -s NAME:DESC, --string=NAME:DESC Add "string" option. (with "-c")  [default:[]]
    -b NAME:DESC, --bool=NAME:DESC   Add "bool"   option. (with "-c")  [default:[]]
    -a NAME:DESC, --array=NAME:DESC  Add "array"  option. (with "-c")  [default:[]]

$ ./clim direct -o ./fib -e 'def fib(n); return n if n < 2; fib(n - 2) + fib(n - 1); end; puts fib(ARGV[0].to_i32)'
./fib
$ ./fib 10
55
```

Use clim library. `-c` or `--clim`
```
$ ./clim direct hello -a name:'Target name.' -s greeting:'Words of greetings.' -e 'puts "#{opts.s["greeting"]},\n#{opts.a["name"].join(", ")}!"' -o ./hello -c

./hello
$ ./hello -h

  Command Line Interface.

  Usage:

    hello_tmp [options] [arguments]

  Options:

    -h, --help                       Show this help.
    -g VALUE, --greeting=VALUE       Words of greetings.
    -n VALUE, --name=VALUE           Target name.  [default:[]]

```

## Contributing

1. Fork it ( https://github.com/at-grandpa/clim/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
