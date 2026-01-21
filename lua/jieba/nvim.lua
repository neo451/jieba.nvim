---keymap
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113
local Motion = require "wordmotion.jieba".Motion

local M = {}

---init if required
function M.init()
    if M.motion == nil then
        local motion = Motion()
        if motion.jieba then
            M.motion = motion
            M.motion:set_keymaps()
        end
    end
end

return M
