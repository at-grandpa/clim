# clim

"clim" is slim command line interface builder and tools.

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

class MyCli < Clim
  main_command
  desc  "My Command Line Interface."
  usage "mycli [sub-command] [options] ..."
  run do |opts, args|
    puts opts.help
  end

  sub do
    command "todo"
    desc    "Generate TODO list."
    usage   "mycli todo [options] ..."
    array   "-i TODO", "--items=TODO", desc: "Add TODO item."
    bool    "-v",      "--vertical",   desc: "Display in vertical."
    run do |opts, args|
      if opts.b["vertical"]
        puts opts.a["items"].join("\n")
      else
        puts opts.a["items"].join(", ")
      end
    end
  end
end

MyCli.start(ARGV)
```

```
$ crystal build mycli.cr
$ ./mycli todo -h

  Generate TODO list.

  Usage:

    mycli todo [options] ...

  Options:

    -h, --help                       Show this help.
    -i TODO, --items=TODO            Add TODO item.  [default:[]]
    -v, --vertical                   Display in vertical.  [default:false]

$ ./mycli todo -i task1 -i task2 -v
task1
task2
```
## Usage

### require

```crystal
require "clim"
```

### main_command / desc / usage / run

```crystal
class MyCli < Clim
  main_command
  desc  "My Command Line Interface."          # main command description.
  usage "mycli [sub-command] [options] ..."   # main command usage.
  run do |opts, args|                         # run block.
    # Put your code here.
  end
end
```

### Options

#### string

```crystal
class MyCli < Clim
  main_command
  desc   "My Command Line Interface."
  usage  "mycli [sub-command] [options] ..."
  string "-s ARG", "--string-long-name=ARG", desc: "Option description."  # string option
  run do |opts, args|
    opts.string["string-long-name"]  # get option value.
    opts.s["string-long-name"]       # same as above.
  end
end
```

#### bool

```crystal
class MyCli < Clim
  main_command
  desc  "My Command Line Interface."
  usage "mycli [sub-command] [options] ..."
  bool  "-b", "--bool-long-name", desc: "Option description."  # bool option
  run do |opts, args|
    opts.bool["bool-long-name"]  # get option value.
    opts.b["bool-long-name"]     # same as above.
  end
end
```

#### array

```crystal
class MyCli < Clim
  main_command
  desc  "My Command Line Interface."
  usage "mycli [sub-command] [options] ..."
  array "-a ITEM", "--array-long-name=ITEM", desc: "Option description."  # array option
  run do |opts, args|
    opts.array["array-long-name"]  # get option value.
    opts.a["array-long-name"]      # same as above.
  end
end
```

### default / required

```crystal
class MyCli < Clim
  main_command
  desc   "My Command Line Interface."
  usage  "mycli [sub-command] [options] ..."
  string "-x VALUE", "--x-axis=VALUE", default: "default value"                  # default value.
  string "-y VALUE", "--y-axis=VALUE", required: true                            # required
  string "-z VALUE", "--z-axis=VALUE", default: "default value", required: true  # both
  run do |opts, args|
    # Put your code here.
  end
end
```

### help

```crystal
class MyCli < Clim
  main_command
  desc   "My Command Line Interface."
  usage  "mycli [sub-command] [options] ..."
  run do |opts, args|
    opts.help  # help string.
  end
end
```

### Sub command

```crystal
class MyCli < Clim
  main_command
  desc   "My Command Line Interface."
  usage  "mycli [sub-command] [options] ..."
  run do |opts, args|
    # Put your code here.
  end
  
  sub do
    command "sub_command1"
    desc    "Sub command 1."
    usage   "mycli sub_commnad1 [options] ..."
    run do |opts, args|
      # Put your code here.
    end
    
    sub do
      command "sub_sub_command"
      desc    "Sub Sub command."
      usage   "mycli sub_commnad1 sub_sub_command [options] ..."
      run do |opts, args|
        # Put your code here.
      end
    end
    
    command "sub_command2"
    desc    "Sub command 2."
    usage   "mycli sub_commnad2 [options] ..."
    run do |opts, args|
      # Put your code here.
    end
  end
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
    direct   Direct build crystal code.

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
    -s NAME:DESC, --string=NAME:DESC Add "string" option.  [default:[]]
    -b NAME:DESC, --bool=NAME:DESC   Add "bool" option.  [default:[]]
    -a NAME:DESC, --array=NAME:DESC  Add "array" option.  [default:[]]

$ ./clim init mycli -s name:'Your name.' -b verbose:'Display verbose.' -a items:'Add items.'

...

$ cd mycli
$ crystal dep

...

$ crystal build src/mycli.cr
$ ./mycli

  Example Command Line Interface

  Usage:

    mycli [options] [arguments]

  Options:

    -h, --help                       Show this help.
    -n VALUE, --name=VALUE           Your name.
    -v, --verbose                    Display verbose.  [default:false]
    -i VALUE, --items=VALUE          Add items.  [default:[]]

```

#### direct

Direct build crystal code.

```
$ ./clim direct -h                                                                                                                                                                                       [master]

  Direct build crystal code.

  Usage:

    clim direct [options] ...

  Options:

    -h, --help                       Show this help.
    -o FILE, --output=FILE           Output filename.  [default:/tmp/crystal.out]
    -e CODE, --eval=CODE             Crystal code to evaluation.  [default:puts "Hello, world!!"]
    -s, --stats                      Enable statistics output.  [default:false]
    -r, --release                    Compile in release mode.  [default:false]

$ ./clim direct -o ./fib --release -e 'def fib(n); return n if n < 2; fib(n - 2) + fib(n - 1); end; puts fib(ARGV[0].to_i32)'
crystal build /path/to/tmp_dir/direct_crystal_build.14Sq1u -o ./fib --release
Build complete. -> ./fib
$ ./fib 10
55
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/clim/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
