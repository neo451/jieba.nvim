---simulate b/e/w/ge
-- luacheck: ignore 111 113
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
    for _, text in ipairs(self.jieba:cut(str)) do
        table.insert(tokens,
            {
                text = text,
                illegal = text:match "%s*" == text,
                start_index = c,
                end_index = c + utf8.offset(text, -1) - 1
            })
        c = c + #text
    end
    return tokens
end

---set keymaps
---@param keymaps {string: boolean[]}}?
---@param modes string[]
function M.Cursor:set_keymaps(keymaps, modes)
    keymaps = keymaps or {
        w = { true, true },
        b = { true, false },
        e = { false, true },
        ge = { false, false },
    }
    modes = modes or { "n", "x" }
    for lhs, args in pairs(keymaps) do
        vim.keymap.set(modes, lhs, self:callback(args[1], args[2]), { noremap = false })
    end
end

return M
