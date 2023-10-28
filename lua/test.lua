
local jieba = require("jieba")
local st = require("stringtools")
local jn = require("jieba_nvim")

TokenType = {hans = 1, punc = 2, space = 3, non_word = 4}
local function test_parse_tokens()
    local tokens = {'Pixelmator', '-', 'Pro', ' ', '在', '设计', '，', '完全'}
    local expected = {
        {0, 9, 1},
        {10, 10, 4},
        {11, 13,1},
        {14, 14, 3},
        {15, 15, 1},
        {18, 21, 1},
        {24, 24, 2},
        {27, 30, 1}
    }
    st.print(jn.parse_tokens(tokens))
    assert(jn.parse_tokens(tokens) == expected)
end

test_parse_tokens()
