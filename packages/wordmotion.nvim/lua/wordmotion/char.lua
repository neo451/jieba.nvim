---simulate h and l
-- luacheck: ignore 212
local Motion = require "wordmotion".Motion
local utf8 = require("utf8")
local M = {
    Motion = {
    }
}

---@param motion table?
---@return table motion
function M.Motion:new(motion)
    motion = motion or {}
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
    for i = 1, utf8.len(str) do
        table.insert(tokens,
            { text = utf8.sub(str, i, i), start_index = utf8.offset(str, i) - 1, end_index = utf8.offset(str, i) - 1 })
    end
    return tokens
end

return M
