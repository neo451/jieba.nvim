---simulate B/E/W/gE
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
    local c = 0
    local space = utf8.match(str, "^%s+")
    if space then
        table.insert(tokens, { text = space, illegal = true, start_index = 0, end_index = utf8.offset(space, -1) - 1 })
        c = c + #space
    end
    for match in utf8.gmatch(str, "%S+%s*") do
        local text = utf8.match(match, "%S+")
        table.insert(tokens, { text = text, start_index = c, end_index = c + utf8.offset(text, -1) - 1 })
        c = c + #text
        space = utf8.match(match, "%s+")
        if space then
            table.insert(tokens,
                { text = space, illegal = true, start_index = c, end_index = c + utf8.offset(space, -1) - 1 })
            c = c + #space
        end
    end
    return tokens
end

return M
