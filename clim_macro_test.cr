module M
  class Opts
    macro string(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      property {{property_name.id}} : String | Nil = nil
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

    macro string(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Array(String).new
        @@defining_command.gsub(/d/, "a")
      end
      {{property_name.id}}_define
    end

    macro bool(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Array(Bool).new
        @@defining_command.gsub(/d/, "a")
      end
      {{property_name.id}}_define
    end

    macro array(short, long)
      {% property_name = long.gsub(/^-*/, "").gsub(/-/, "_") %}
      def self.{{property_name.id}}_define
        opt = Array(Array(String)).new
        @@defining_command.gsub(/d/, "a")
      end
      {{property_name.id}}_define
    end

    macro options(name)
      class {{name.camelcase.id}} < Opts
        {{yield}}
      end

      def self.{{name.id}}_set_opts
        opts = {{name.camelcase.id}}.new
        @@defining_command.gsub(/d/, "a")
      end
      {{name.id}}_set_opts

      {{yield}}

    end

    options(name: "ttt") do
      # これらが呼び出される度に、commandへのaddとOptionParserへの登録が行われる
      # くー、class間のnamespaceが邪魔をする
      # あー。今回はoptsがいろいろ変わるわけで、Optionは変わらんか
      # optsを外から入れられるようにしないとだめっぽい
      # うーん、だめだな
      # optとoptsの構成を変えないとだめっぽい
      # optsはそのままrun_procの引数にしよう Clim::Options
      # で、各run_procには、別々のoptsが入ってくる
      # クラス名は変えなくても良いかも、いやだめか。各コマンド毎にoptsのメソッドが異なるから、これはだめっぽい
      # 決めたこと
      #   - run_procにはoptsのオブジェクトが入ってくる
      #   - 各コマンドのoptsは、コマンドの名前のクラスになる Optsを継承
      #   - 各optsはオプションのメソッドにアクセスできる

      string "-n", "--name"
      bool "-w", "--web"
      array "-d", "--dogs"
      string "-s", "--stay-with-me"
    end
  end
end
