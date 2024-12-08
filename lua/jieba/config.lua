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

local dict_dir = joinpath(
    dirname(debug.getinfo(1).source:match("@?(.*)")),
    "dict"
)

return {
    hmm = true,
    paths = {
        dict_path = joinpath(dict_dir, "jieba.dict.utf8"),
        model_path = joinpath(dict_dir, "hmm_model.utf8"),
        user_dict_path = arg[0]:match("%.exe") and "nul" or "/dev/null",
        idf_path = joinpath(dict_dir, "idf.utf8"),
        stop_word_path = joinpath(dict_dir, "stop_words.utf8"),
    }
}
