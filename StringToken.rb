# -*- coding: utf-8 -*-


# 文字列単位のトークンクラス
class StringToken

    module TokenType
        TYPE_ERROR = 'error'.freeze     # エラー
        TYPE_NONE = 'none'.freeze       # 通常文字列
        TYPE_PERCENT = ''.freeze        # (指定時は%%とするため、文字列が存在しない場合は%指定となる)
        TYPE_BIT = 'b'.freeze           # 2進数
        TYPE_OCTAL = 'o'.freeze         # 8進数
        TYPE_DIGIT = 'd'.freeze         # 10進数
        TYPE_HEX_UPPER = 'H'.freeze     # 16進数(大文字)
        TYPE_HEX_LOWER = 'h'.freeze     # 16進数(小文字)
        TYPE_MARK = 'm'.freeze          # 記号
        TYPE_MARK_DETAIL = 'M'.freeze   # 記号(詳細)
        TYPE_STRING = 's'.freeze        # 0-9 + A-Z + a-Z

        def self.all
            self.constants.map{ |type| eval("#{type}") }
        end
    end


    def initialize
        @type = TokenType::TYPE_NONE
        @word = ""
        @num = 0
    end


    def ParseString( word )
        @type = TokenType::TYPE_NONE
        @word = word
        @num = 1

        return true
    end

    # 特殊文字の場合
    # 開始文字%%は省いて指定
    def ParseSpecialString( word )

        # 空白文字時は%が1つ指定されたものとして扱う
        if word.empty? then
            @type = TokenType::TYPE_PERCENT
            @word = ''
            @num = 0
            return true
        end


        # 生成文字数の取得
        idx = word.index(  /[^0-9]/, 0 )
        if idx == nil then
            puts "特殊文字に数字が指定されていません"
            return false
        end


        # 基本的に意味のない%0sなどの指定は不可(最低1は保証させる)
        @num = [1, word[0, idx].to_i].max
        pos = idx

        # 生成識別タイプ算出
        specifier = word[pos, word.length]

        type = TokenType.all().find{ |item| specifier == item }
        if type == nil then
            puts "特殊文字に登録されていない文字列が指定されました : " + specifier
            return false
        end

        @type = type
        @word = ''
        return true
    end

    def CreateString()
        # 通常文字時はそのまま対象文字を返す
        return @word if @type == TokenType::TYPE_NONE
        
        wordList = GetWordList( @type )
        return '' if wordList == nil

        output = ''
        (0...@num).each do |i| 
            output += wordList[rand(wordList.length)]
        end

        return output
    end

private
    def GetWordList( type )

        wordList = nil
        case type
        when TokenType::TYPE_PERCENT then
            wordList = ('%').to_a
        when TokenType::TYPE_BIT then
            wordList = ('0'..'1').to_a
        when TokenType::TYPE_OCTAL then
            wordList = ('0'..'7').to_a
        when TokenType::TYPE_DIGIT then
            wordList = ('0'..'9').to_a
        when TokenType::TYPE_HEX_UPPER then
            wordList = ('0'..'9').to_a + ('A'..'F').to_a
        when TokenType::TYPE_HEX_LOWER then
            wordList = ('0'..'9').to_a + ('a'..'f').to_a
        when TokenType::TYPE_MARK then
            wordList = ( '!"#$%&\'=~|-^\@;:/\`+*?_' ).split("")
        when TokenType::TYPE_MARK_DETAIL then
            wordList = ( '!"#$%&\'=~|-^\@;:/\`+*?_' ).split("") + ( "(){}[]<>" ).split("")
        when TokenType::TYPE_STRING then
            wordList = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
        else
            puts "定義されていない識別子が指定されています #{word}"
        end

        return wordList
    end
end
