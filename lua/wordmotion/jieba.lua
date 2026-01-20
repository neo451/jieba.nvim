---simulate b/e/w/ge
local Cursor = require "wordmotion".Cursor
local Jieba = require("jieba.jieba").Jieba
local M = {
    Cursor = {
    }
}

---@param cursor table?
---@return table cursor
function M.Cursor:new(cursor)
    cursor = cursor or {}
    cursor.jieba = cursor.jieba or Jieba()
    cursor = Cursor(cursor)
    setmetatable(cursor, {
        __index = self
    })
    return cursor
end

setmetatable(M.Cursor, {
    __index = Cursor,
    __call = M.Cursor.new
})

---cut string. abstract method
---@param str string
---@return {text: string, illegal: boolean?, start_index: integer, end_index: integer}[]
function M.Cursor:get_tokens(str)
    local tokens = {}
    local c = 0
    for text in self.jieba:cut(str) do
        table.insert(tokens,
            { text = text, illegal = text:match "%s*" == text, start_index = c, end_index = c + #text - 1 })
        c = c + #text
    end
    return tokens
end

return M
