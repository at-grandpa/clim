require "./clim"

# あとはバリデーションかなー
# versionとか -> macroですぐにできる
# optionいくか
#
# TODO:
# [done] 型の増加
# [done] defaultが設定されていたら T? じゃなくて T にする
# [done] helpの充実
# [done] shortのみ、longのみ
# [done] versionの実装
# [done] rescue
# [done] You can not specify 'required: true' for Bool option. のテスト
# サポートしていない型だったらエラー
# 同じコマンドを指定した場合の動作
#   - macro raise でキャッチ
# 型が違った場合の挙動
# モジュールの切り出し

# class MyCli < Clim
#  main_command do
#    desc "main command."
#    option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
#    option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
#    run do |options, arguments|
#      p "main ---"
#      p options.name
#      p options.time
#      p arguments
#      p "---"
#    end
#    sub_command "sub1" do
#      desc "desc sub1."
#      option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
#      option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
#      run do |options, arguments|
#        p "sub1 ---"
#        p options.name
#        p options.time
#        p "---"
#      end
#      sub_command "subsub1" do
#        desc "desc subsub1."
#        option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
#        option "-t", "--time=TIME", type: Int32, desc: "your time.", default: 4, required: true
#        option "-b", "--bool", type: Bool, desc: "your bool.", default: false, required: true
#        run do |options, arguments|
#          p "subsub1 ---"
#          p options.name
#          p options.time
#          p options.bool
#          p arguments
#          p "---"
#        end
#      end
#    end
#  end
# end

class MyCli < Clim
  main_command do
    version "Version 1.0.0", short: "-v"
    desc "main command."
    option "-n", "--name=NAME", type: String, desc: "your name.", default: "Taro", required: true
    option "-b", type: Bool, desc: "your bool.", required: true
    run do |options, arguments|
      p "main ---"
      p options.name
      p arguments
      p "---"
    end
  end
end

MyCli.start(ARGV)
