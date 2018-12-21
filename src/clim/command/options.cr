require "./options/*"

class Clim
  abstract class Command
    class Options
      property help_str : String = ""

      def invalid_required_names
        ret = [] of String | Nil
        {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_str" } %}
          short_or_nil = {{iv}}.required_not_set? ? {{iv}}.short : nil
          ret << short_or_nil
        {% end %}
        ret.compact
      end

      def setup_parser(parser)
        # options
        {% for iv in @type.instance_vars.reject { |iv| ["help_str", "help_instance", "version_instance"].includes?(iv.stringify) } %}
          long = {{iv}}.long
          if long.nil?
            parser.on({{iv}}.short, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          else
            parser.on({{iv}}.short, long, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          end
        {% end %}

        # help
        {% if @type.instance_vars.map(&.stringify).includes?("help_instance") %}
          {% iv = @type.instance_vars.find(&.stringify.==("help_instance")) %}
          long = {{iv}}.long
          if long.nil?
            parser.on({{iv}}.short, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          else
            parser.on({{iv}}.short, long, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          end
        {% end %}

        # version
        {% if @type.instance_vars.map(&.stringify).includes?("version_instance") %}
          {% iv = @type.instance_vars.find(&.stringify.==("version_instance")) %}
          long = {{iv}}.long
          if long.nil?
            parser.on({{iv}}.short, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          else
            parser.on({{iv}}.short, long, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          end
        {% end %}
      end

      def info
        {% begin %}
          {% support_types = SUPPORT_TYPES.map { |k, _| k } + [Nil] %}
          array = [] of NamedTuple(name: Array(String), type: {{ support_types.map(&.stringify.+(".class")).join(" | ").id }}, desc: String, default: {{ support_types.join(" | ").id }}, required: Bool)
          {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help_str" } %}
            array << {{iv}}.to_named_tuple
          {% end %}
        {% end %}
      end
    end
  end
end
