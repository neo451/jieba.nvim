---simulate ^ and $
local Cursor = require "wordmotion".Cursor
local M = {
    Cursor = {
        keep = true,
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

return M
