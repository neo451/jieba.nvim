---simulate h and l
-- luacheck: ignore 212
local Cursor = require "wordmotion".Cursor
local utf8 = require("utf8")
local M = {
    Cursor = {
    }
}

---@param cursor table?
---@return table cursor
function M.Cursor:new(cursor)
    cursor = cursor or {}
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
    for i = 1, utf8.len(str) do
        table.insert(tokens,
            { text = utf8.sub(str, i, i), start_index = utf8.offset(str, i) - 1, end_index = utf8.offset(str, i) - 1 })
    end
    return tokens
end

return M
