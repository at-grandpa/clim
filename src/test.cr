class C
  macro my_macro(type)
    class G({{type}})
      property var : {{type}}? = nil
      def set(arg : String)
        \{% begin %}
          \{% type_hash = {
            Int32  => "to_i32",
            String => "to_s",
            Bool => "==(\"true\")",
          } %}
          \{% p @type.type_vars %}
          \{% type_ver = @type.type_vars.first %}
          \{% convert_method = type_hash[type_ver] %}
          @var = arg.\{{convert_method.id}}
        \{% end %}
      end
    end

    def get_opt
      G({{type}}).new
    end
  end
end

class M < C
  my_macro(Bool)
end

m = M.new
g = m.get_opt
g.set("true")
p g.var
p g.var.class
