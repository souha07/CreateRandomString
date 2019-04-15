# -*- coding: utf-8 -*-

# 指定した文字列からランダムな文字列を生成して返す
require './RandomString'


########################################
# main
########################################

# 引数チェック
if ARGV.size < 2
    puts "Argument Error"
    puts "  ARGV[0] = format string"
    puts "  ARGV[1] = createNum"
    puts "  ARGV[2] = result filename"

    exit
end
format = ARGV[0]
createNum = ARGV[1].to_i

# 結果ファイル名があれば設定、なければresult.txt
result = "./result.txt"
result = ARGV[2].dup if ARGV[2] != nil 


# ランダム文字列生成
rs = RandomString.new()
outList = rs.Create( format, createNum )

outList.each { |item| puts item.encode( "UTF-8" ) } 
puts ""

# 結果書き込み
File::open( result, "w" ) do |wf|
    outList.each do |item|
        wf.puts( item )
    end
end

puts "complete"