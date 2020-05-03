require "./arguments/*"

class Clim
  abstract class Command
    class Arguments
      property help_string : String = ""
      property command_args : Array(String) = [] of String
      property unknown_args : Array(String) = [] of String

      def set_unknown_args(args : Array(String))
        @unknown_args = args
      end

      def unknown_args
        @unknown_args
      end

      def update_command_args(command_args)
        # ここでArgumentの配列を作る
        tmp = [] of String
        command_args.each do |element|
          tmp << element
        end
        @command_args = tmp
      end

      def list
        @command_args
      end

      def invalid_required_names
        ret = [] of String | Nil
        {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "command_args" || iv.stringify == "unknown_args" } %}
          short_or_nil = {{iv}}.required_not_set? ? {{iv}}.short : nil
          ret << short_or_nil
        {% end %}
        ret.compact
      end

      def info
        {% begin %}
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of NamedTuple(names: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool)
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "command_args" || iv.stringify == "unknown_args" } %}
            array << {{iv}}.to_named_tuple
          {% end %}
        {% end %}
      end

      def to_a
        {% begin %}
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of Argument
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "command_args" || iv.stringify == "unknown_args" } %}
            array << {{iv}}
          {% end %}
        {% end %}
      end
    end
  end
end
