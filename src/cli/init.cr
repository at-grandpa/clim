require "yaml"
require "./file_creator"
require "./path"

class Cli
  class Init
    def self.run(opts, args, silent = false)
      raise "CLI tool name is necessary." if args.empty?
      name = args.first
      raise "Invalid type. \"#{name}\" must be String." unless name.is_a?(String)
      raise "Invalid name. Please name with /\\A[a-zA-Z][a-zA-Z0-9-_]+\\z/" unless valid_name?(name)
      code = opts.s["eval"]
      opts.a.delete("help")
      validate_opts(opts.a)
      opt_codes = convert_to_code(opts.a)
      dev_null = silent ? ">> /dev/null" : ""
      system("crystal init app #{name} #{dev_null}")
      puts ""
      create_shard_yml(name, silent)
      create_src_file(name, opt_codes, code, silent)
    end

    def self.valid_name?(name)
      !!name.match(/\A[a-zA-Z][a-zA-Z0-9-_]+\z/)
    end

    def self.validate_opts(opts)
      opts.each do |opt_name, opt_value|
        raise "Invalid type option value. must be Array(String)." unless opt_value.is_a?(Array(String))
        opt_value.each do |value|
          raise "Invalid option format. Please use the following format. \"NAME:DESC\"" unless valid_opts_format?(value)
        end
      end
    end

    def self.valid_opts_format?(value)
      !!value.match(/\A[a-zA-Z][a-zA-Z0-9-_]+?:.+\z/)
    end

    def self.convert_to_code(opts)
      codes = [] of String
      short_names = [] of String
      opts.each do |opt_name, value_array|
        next unless ["string", "bool", "array"].includes?(opt_name)
        raise "Invalid type option value. must be Array(String)." unless value_array.is_a?(Array(String))
        value_array.each do |value|
          name, desc = value.split(":", 2)
          short = name[0].to_s
          raise "Short name \"#{short}\" is duplicated. Please specified other option name." if short_names.includes?(short)
          if opt_name == "bool"
            codes << "#{opt_name} \"-#{short}\", \"--#{name}\", desc: \"#{desc}\""
          else
            codes << "#{opt_name} \"-#{short} VALUE\", \"--#{name}=VALUE\", desc: \"#{desc}\""
          end
          short_names << short
        end
      end
      codes
    end

    def self.create_shard_yml(name, silent)
      dependencies = {
        dependencies: {
          clim: {
            github: "at-grandpa/clim",
            branch: "master",
          },
        },
      }
      path = "#{Path.pwd}/#{name}/shard.yml"
      puts "      #{"clim update".colorize(:light_green)}  #{path}" unless silent
      File.open(path, "a") { |f| f.puts dependencies.to_yaml.gsub(/\A---/, "") }
    end

    def self.create_src_file(name, opt_codes, code, silent)
      FileCreator.create(
        "#{Path.pwd}/#{name}/src/#{name}.cr",
        "src_file.ecr",
        {
          cmd_name:  name,
          opt_codes: opt_codes,
          code: code,
        },
        silent
      )
    end
  end
end
