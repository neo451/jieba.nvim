---simulate B/E/W/gE
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
    local c = 0
    local space = utf8.match(str, "^%s+")
    if space then
        table.insert(tokens, { text = space, illegal = true, start_index = 0, end_index = #space - 1 })
        c = c + #space
    end
    for match in utf8.gmatch(str, "%S+%s*") do
        local text = utf8.match(match, "%S+")
        table.insert(tokens, { text = text, start_index = c, end_index = c + #text - 1 })
        c = c + #text
        space = utf8.match(match, "%s+")
        if space then
            table.insert(tokens, { text = space, illegal = true, start_index = c, end_index = c + #space - 1 })
            c = c + #space
        end
    end
    return tokens
end

return M
