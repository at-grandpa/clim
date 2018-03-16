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
# [done] 同じコマンドを指定した場合の動作
#   - macro raise でキャッチ
# [done] サポートしていない型だったらエラー
# [done] 型が違った場合の挙動
#   - 難し良いので諦め
# モジュールの切り出し

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
