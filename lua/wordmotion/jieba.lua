---simulate b/e/w/ge
-- luacheck: ignore 111 113
local Motion = require "wordmotion".Motion
local Jieba = require("jieba.jieba").Jieba
local M = {
    Motion = {
    }
}

---@param motion table?
---@return table motion
function M.Motion:new(motion)
    motion = motion or {}
    motion.jieba = motion.jieba or Jieba()
    motion = Motion(motion)
    setmetatable(motion, {
        __index = self
    })
    return motion
end

setmetatable(M.Motion, {
    __index = Motion,
    __call = M.Motion.new
})

---cut string. abstract method
---@param str string
---@return {text: string, illegal: boolean?, start_index: integer, end_index: integer}[]
function M.Motion:get_tokens(str)
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
function M.Motion:set_keymaps(keymaps, modes)
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
