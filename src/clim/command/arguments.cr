require "./arguments/*"

class Clim
  abstract class Command
    class Arguments
      property help_string : String = ""
      property unknown_args : Array(String) = [] of String

      def set_unknown_args(args : Array(String))
        @unknown_args = args
      end

      def unknown_args
        @unknown_args
      end

      def invalid_required_names
        ret = [] of String | Nil
        {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "unknown_args" } %}
          name_or_nil = {{iv}}.required_not_set? ? {{iv}}.display_name : nil
          ret << name_or_nil
        {% end %}
        ret.compact
      end

      def info
        {% begin %}
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of NamedTuple(method_name: String, display_name: String, type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool)
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "unknown_args" } %}
            array << {{iv}}.to_named_tuple
          {% end %}
        {% end %}
      end

      def to_a
        {% begin %}
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of Argument
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" || iv.stringify == "unknown_args" } %}
            array << {{iv}}
          {% end %}
        {% end %}
      end
    end
  end
end
