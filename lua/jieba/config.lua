--- default config. See `lua vim.print(require"jieba.config")`.
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113

---get dirname
---@param dir string
---@return string
local function dirname(dir)
    if vim then
        return vim.fs.dirname(dir)
    end
    local result, _ = dir:gsub("/[^/]+/?$", "")
    return result
end

---join two paths
---@param dir string
---@param file string
---@return string
local function joinpath(dir, file)
    if vim then
        return vim.fs.joinpath(dir, file)
    end
    return dir .. "/" .. file
end

---judge if OS is win32
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
    --- if hmm is enabled
    hmm = true,
    --- config for paths
    paths = {
        dict_path = joinpath(dict_dir, "jieba.dict.utf8"), -- for dict
        model_path = joinpath(dict_dir, "hmm_model.utf8"), -- for model
        user_dict_path = has_win32() and "nul" or "/dev/null", -- for user dict
        idf_path = joinpath(dict_dir, "idf.utf8"), -- for idf
        stop_word_path = joinpath(dict_dir, "stop_words.utf8"), -- for stop words
    }
}
