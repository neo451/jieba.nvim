---keymap
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113
local Cursor = require "wordmotion.jieba".Cursor

local M = {}

---init if required
function M.init()
    if M.cursor == nil then
        local cursor = Cursor()
        if cursor.jieba then
            M.cursor = cursor
            M.cursor:set_keymaps()
        end
    end
end

return M
