module M
  class Opts
    macro string(short, long)
      property {{long.gsub(/^-*/, "").gsub(/-/, "_").id}} : String | Nil = nil
    end

    macro bool(short, long)
      property {{long.gsub(/^-*/, "").gsub(/-/, "_").id}} : Bool | Nil = nil
    end

    macro array(short, long)
      property {{long.gsub(/^-*/, "").gsub(/-/, "_").id}} : Array(String) | Nil = nil
    end
  end
end

module M
  class C
    macro options(name)
      class {{name.camelcase.id}} < Opts
        {{yield}}
      end

      def self.{{name.id}}_define_opts
        opts = {{name.camelcase.id}}.new
      end
      {{name.id}}_define_opts
    end

    options(name: "ttt") do
      string "-s", "--string"
      bool "-b", "--bool"
      array "-a", "--array"
    end
  end
end
