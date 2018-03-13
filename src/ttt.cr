class M
  class G(Int32)
    @var : Int32 | ::Nil = nil

    def var : Int32 | ::Nil
      @var
    end

    def var=(var : Int32 | ::Nil)
      @var = var
    end

    def set(arg : String)
      {% if true %}
             {% type_hash = {Int32 => "to_i32", String => "to_s"} %}
             {% p(@type.type_vars) %}
             {% type_ver = @type.type_vars.first %}
             {% convert_method = type_hash[type_ver] %}
             @var = arg.{{ convert_method.id }}
           {% end %}
    end
  end

  def get_opt
    G(Int32).new
  end
end

m = M.new
g = m.get_opt
g.set("1")
p g
p g.var
p g.var.class
