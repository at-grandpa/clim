require "./options/*"

class Clim
  abstract class Command
    class Options
      property help_string : String = ""

      def invalid_required_names
        ret = [] of String | Nil
        {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" } %}
          short_or_nil = {{iv}}.required_not_set? ? {{iv}}.short : nil
          ret << short_or_nil
        {% end %}
        ret.compact
      end

      def info
        {% begin %}
          {% support_types = SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
          array = [] of NamedTuple(names: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool)
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" } %}
            array << {{iv}}.to_named_tuple
          {% end %}
        {% end %}
      end

      def to_a
        {% begin %}
          {% support_types = SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
          array = [] of Option
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" } %}
            array << {{iv}}
          {% end %}
        {% end %}
      end
    end
  end
end
