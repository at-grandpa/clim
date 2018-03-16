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
    end
  end
end
