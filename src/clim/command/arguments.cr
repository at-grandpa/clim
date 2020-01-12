require "./arguments/*"

class Clim
  abstract class Command
    class Arguments < Array(String)
      property help_string : String = ""
      property command_args : Array(String) = [] of String

      def update_command_args(command_args)
        self.clear
        command_args.each do |element|
          self << element
        end
      end

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
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of NamedTuple(names: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool)
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" } %}
            array << {{iv}}.to_named_tuple
          {% end %}
        {% end %}
      end

      def to_a
        {% begin %}
          {% support_types = SUPPORTED_TYPES_OF_ARGUMENT.map { |k, _| k } + [Nil] %}
          array = [] of Option
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_string" } %}
            array << {{iv}}
          {% end %}
        {% end %}
      end
    end
  end
end
