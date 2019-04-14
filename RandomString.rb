# -*- coding: utf-8 -*-


# ランダムな文字列を生成するクラス(printfライク)
class RandomString
    def initialize
    end

    def Create( format, num )

        @isError = false
        outputList = Array.new();

        format = Parse( format )

        (0...num).each do |i|
            outputList.push( CreateString(format) )
        end

        return outputList
    end

private
    # 文字列生成前の解析処理
    # %4sであれば、%s%s%s%sと分離する
    def Parse( format )
        output = ""

        pos = 0
        while pos < format.length do
            ch = format[pos]
            if ch == '%' then
                # %指定時の各種処理
                pos += 1

                # 生成文字数の取得
                idx = format.index(  /[^0-9]/, pos )
                if idx == nil then
                    # エラー時
                    puts "%指定後の数値指定が不正 : #{format} : pos : #{pos}"
                    isError = true
                    return
                end

                # 基本的に意味のない%0sなどの指定は不可(最低1は保証させる)
                num = [1, format[pos, idx - pos].to_i].max
                pos += idx - pos

                # 生成タイプの取得
                specifier = format[pos, 1]
                (0...num).each { || output += "%#{specifier}" }
                pos += specifier.length

                next
            end
            
            output += ch
            pos += 1
        end

        return output
    end


    # 文字列生成処理
    def CreateString( format )

        output = ''

        pos = 0
        while pos < format.length do
            ch = format[pos]
            if ch == '%' then
                # %指定時の各種処理
                pos += 1

                # 生成タイプの取得（取得すべきランダム配列の取得)
                wordList = nil
                case format[pos, 1]
                when 's' then
                    wordList = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
                when 'd' then
                    wordList = ('0'..'9').to_a
                when '%' then
                    wordList = ('%').to_a
                else
                    puts "定義されていない識別子が指定されている #{format[pos, 1]}"
                    isError = true
                    return
                end

                output += wordList[rand(wordList.length)]
                pos += 1
                next
            end
            
            output += ch
            pos += 1
        end

        return output
    end
end

