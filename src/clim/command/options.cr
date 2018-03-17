require "./options/*"

class Clim
  abstract class Command
    class Options
      property help : String = ""

      def invalid_required_names
        ret = [] of String | Nil
        {% for iv in @type.instance_vars.reject { |iv| iv.stringify == "help" } %}
          short_or_nil = {{iv}}.required_set? ? {{iv}}.short : nil
          ret << short_or_nil
        {% end %}
        ret.compact
      end

      def setup_parser(parser)
        {% for iv in @type.instance_vars.reject{|iv| iv.stringify == "help"} %}
          long = {{iv}}.long
          if long.nil?
            parser.on({{iv}}.short, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          else
            parser.on({{iv}}.short, long, {{iv}}.desc) {|arg| {{iv}}.set_value(arg) }
          end
        {% end %}
      end
    end
  end
end
