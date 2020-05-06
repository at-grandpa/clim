require "option_parser"

class Clim
  abstract class Command
    class Parser(O, A)
      property option_parser : OptionParser = OptionParser.new
      property options : O
      property arguments : A
      property unknown_args_property : Array(String) = [] of String

      def initialize(@options : O, @arguments : A)
        @option_parser.invalid_option { |opt_name| raise ClimInvalidOptionException.new "Undefined option. \"#{opt_name}\"" }
        @option_parser.missing_option { |opt_name| raise ClimInvalidOptionException.new "Option that requires an argument. \"#{opt_name}\"" }
        @option_parser.unknown_args { |ua| @unknown_args_property = ua }
        setup_option_parser(@option_parser)
      end

      def parse(argv : Array(String))
        @option_parser.parse(argv.dup)
      end

      def display_help?
        options = @options
        return false unless options.responds_to?(:help)
        options.help
      end

      def set_arguments
        unknown_args = @unknown_args_property.dup
        args_array = @arguments.to_a
        defined_args_size = args_array.size
        unknown_args_size = unknown_args.size

        if defined_args_size < unknown_args_size
          defined_args_values = unknown_args.shift(defined_args_size)
          defined_args_values.each_with_index do |value, i|
            args_array[i].set_value(value)
          end
          @arguments.set_unknown_args(unknown_args)
        elsif defined_args_size == unknown_args_size
          defined_args_values = unknown_args.shift(defined_args_size)
          defined_args_values.each_with_index do |value, i|
            args_array[i].set_value(value)
          end
          @arguments.set_unknown_args(unknown_args)
        elsif unknown_args_size < defined_args_size
          defined_args_values = unknown_args.shift(defined_args_size)
          defined_args_values.each_with_index do |value, i|
            args_array[i].set_value(value)
          end
          @arguments.set_unknown_args(unknown_args)
        end
      end

      def set_arguments_argv(argv : Array(String))
        @arguments.set_argv(argv)
      end

      def set_help_string(str)
        @options.help_string = str
      end

      def required_validate!
        unless display_help?
          raise "Required options. \"#{options.invalid_required_names.join("\", \"")}\"" unless options.invalid_required_names.empty?
          raise "Required arguments. \"#{arguments.invalid_required_names.join("\", \"")}\"" unless arguments.invalid_required_names.empty?
        end
      end

      def setup_option_parser(option_parser)
        # options
        options = @options.to_a
        options.reject { |o| ["help", "version"].includes?(o.method_name) }.each do |option|
          on(option)
        end

        # help
        option_help = options.find { |o| ["help"].includes?(o.method_name) }
        raise ClimException.new("Help option setting is required.") if option_help.nil?
        on(option_help)

        # version
        option_version = options.find { |o| ["version"].includes?(o.method_name) }
        return nil if option_version.nil?
        on(option_version)
      end

      def on(option)
        long = option.long
        if long.nil?
          option_parser.on(option.short, option.desc) { |arg| option.set_value(arg) }
        else
          option_parser.on(option.short, long, option.desc) { |arg| option.set_value(arg) }
        end
      end

      def options_help_info
        option_parser.@flags.map do |flag|
          info = options.info.find do |info|
            !!flag.match(/\A\s+?#{info[:names].join(", ")}/)
          end
          next nil if info.nil?
          info.merge({help_line: flag})
        end.compact
      end

      def arguments_help_info
        tmp_array = arguments.to_a.map(&.display_name.size)
        max_name_size = tmp_array.empty? ? nil : tmp_array.max
        arguments.to_a.map_with_index(offset = 1) do |argument, i|
          info = arguments.info.find do |info|
            !!argument.display_name.match(/\A#{info[:display_name]}\z/)
          end
          next nil if info.nil?
          next nil if max_name_size.nil?
          info.merge({help_line: "    %02d. %-#{max_name_size}s      %s" % [i, argument.display_name.to_s, argument.desc]})
        end.compact
      end
    end
  end
end
