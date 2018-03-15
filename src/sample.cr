require "./clim"

# あとはバリデーションかなー
# versionとか -> macroですぐにできる
# optionいくか
#
# TODO:
# 型の増加
# 型が違った場合の挙動
# rescue
# 同じコマンドを指定した場合の動作
#   - macro raise でキャッチ
# [done] helpの充実
# テスト
# versionの実装
# [done] shortのみ、longのみ
# モジュールの切り出し
# defaultが設定されていたら T? じゃなくて T にする

class MyCli < Clim
  main_command do
    desc "main command."
    option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
    option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
    run do |options, arguments|
      p "main ---"
      p options.name
      p options.time
      p arguments
      p "---"
    end
    sub_command "sub1" do
      desc "desc sub1."
      option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
      option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
      run do |options, arguments|
        p "sub1 ---"
        p options.name
        p options.time
        p "---"
      end
      sub_command "subsub1" do
        desc "desc subsub1."
        option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
        option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
        option "-b", "--bool", type: Bool, desc: "your bool.", default: false, required: true
        run do |options, arguments|
          p "subsub1 ---"
          p options.name
          p options.time
          p options.bool
          p arguments
          p "---"
        end
      end
    end
  end
end

MyCli.start(ARGV)
