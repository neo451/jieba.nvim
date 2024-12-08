-- luacheck: ignore 112 113
---@diagnostic disable: undefined-global

---@param dir string
---@return string
local function dirname(dir)
    if vim then
        return vim.fs.dirname(dir)
    end
    local result, _ = dir:gsub("/[^/]+/?$", "")
    return result
end

---@param dir string
---@param file string
---@return string
local function joinpath(dir, file)
    if vim then
        return vim.fs.joinpath(dir, file)
    end
    return dir .. "/" .. file
end

---@return boolean
local function has_win32()
    if vim then
        return vim.fn.has("win32") == 1
    end
    return arg[0] and arg[0]:match("%.exe")
end

local dict_dir = joinpath(
    dirname(debug.getinfo(1).source:match("@?(.*)")),
    "dict"
)

return {
    hmm = true,
    paths = {
        dict_path = joinpath(dict_dir, "jieba.dict.utf8"),
        model_path = joinpath(dict_dir, "hmm_model.utf8"),
        user_dict_path = has_win32() and "nul" or "/dev/null",
        idf_path = joinpath(dict_dir, "idf.utf8"),
        stop_word_path = joinpath(dict_dir, "stop_words.utf8"),
    }
}
