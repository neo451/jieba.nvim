---keymap
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113
local M = {
    keymaps = {
        w = { { "n", "x" }, { true, true } },
        b = { { "n", "x" }, { true, false } },
        e = { { "n", "x" }, { false, true } },
        ge = { { "n", "x" }, { false, false } },
    }
}

---init if required
function M.init()
    if M.motion == nil then
        local Motion = require "wordmotion.jieba".Motion
        M.motion = Motion(M.jieba_motion)
    end
end

---set keymaps
---@param keymaps {string: {[1]: string[], [2]: boolean[]}}}?
function M.set_keymaps(keymaps)
    keymaps = keymaps or M.keymaps
    for lhs, keymap in pairs(keymaps) do
        local modes = keymap[1]
        local args = keymap[2]
        vim.keymap.set(modes, lhs,
            function()
                M.init()
                M.motion:callback(args[1], args[2])()
            end,
            { noremap = true })
    end
end

return M
