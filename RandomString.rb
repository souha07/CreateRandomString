# -*- coding: utf-8 -*-

require './StringToken'


# ランダムな文字列を生成するクラス(printfライク)
class RandomString
    def initialize
    end

    def Create( format, num )

        outputList = Array.new();

        isSuccess = Parse( format )
        return outputList if isSuccess == false

        (0...num).each do |i|
            outputList.push( CreateString(format) )
        end

        return outputList
    end

private
    # 文字列生成前の解析処理
    def Parse( format )

        @tokenList = Array.new()

        output = ""
        reg = /%.*%/

        pos = 0
        while pos < format.length do
            spos = format.index( reg, pos )
            if spos == nil then
                output += format[pos, format.length]
                break
            end

            # 通常文字設定
            if pos != spos then
                token = StringToken.new()
                isSuccess = token.ParseString( format[pos, spos - pos] )
                return false if isSuccess == false

                @tokenList.push( token )
            end


            # %%間の文字列取得
            token = StringToken.new()
            pos = spos + 1
            epos = format.index( '%', pos )
            isSuccess = token.ParseSpecialString( format[pos, epos - pos] )
            return false if isSuccess == false

            @tokenList.push( token )

            pos = epos + 1
        end

        return true
    end


    # 文字列生成処理
    def CreateString( format )

        output = ""
        @tokenList.each do |item|
            output += item.CreateString()
        end

        return output
    end
end

