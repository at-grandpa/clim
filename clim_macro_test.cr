module M
  class Opts
    macro string(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      {% is_opts = @type.superclass.name == "M::C::Opts" %}
      {% if is_opts %}
        property {{property_name.id}} : String | Nil = nil
      {% else %}
        def define
          puts {{property_name.stringify}}
        end
      {% end%}
    end

    macro bool(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      property {{property_name.id}} : Bool | Nil = nil
    end

    macro array(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      property {{property_name.id}} : Array(String) | Nil = nil
    end
  end
end

module M
  class C
    @@defining_command : String = "def"

    macro options(name)
      class {{name.camelcase.id}} < Opts
        {{yield}}
      end

      {{yield}}

      def self.{{name.id}}_define_opts
        opts = {{name.camelcase.id}}.new
      end
      {{name.id}}_define_opts
    end

    options(name: "ttt") do
      # これらが呼び出される度に、commandへのaddとOptionParserへの登録が行われる
      # くー、class間のnamespaceが邪魔をする
      string "-n", "--name"
      bool "-w", "--web"
      array "-d", "--dogs"
    end
  end
end
