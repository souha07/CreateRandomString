# -*- coding: utf-8 -*-

# 指定した文字列からランダムな文字列を生成して返す
require './RandomString'


########################################
# main
########################################
rs = RandomString.new()
outList = rs.Create( "あいうえお-%4d", 10 )

puts outList

puts "complete"