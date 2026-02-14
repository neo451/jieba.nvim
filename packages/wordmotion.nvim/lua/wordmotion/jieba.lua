---simulate b/e/w/ge
-- luacheck: ignore 111 113
local Motion = require "wordmotion".Motion
local M = {
    backends = {
        "rjieba.jieba",
        "jieba.jieba",
        "jieba.jieba-lua",
    },
    Motion = {
    }
}

---@param motion table?
---@return table motion
function M.Motion:new(motion)
    motion = motion or {}
    if motion.jieba == nil then
        for _, backend in ipairs(M.backends) do
            local ok, mod = pcall(require, backend)
            if ok then
                motion.jieba = mod.Jieba()
                break
            end
        end
    end
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

---cut string to get **non-empty** words: `utf8.offset("", -1) == nil`
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

return M
