-- luacheck: ignore 112 113
---@diagnostic disable: undefined-global
local dict_dir = vim.fs.joinpath(
    vim.fs.dirname(vim.fs.dirname(debug.getinfo(1).source:match("@?(.*)"))),
    "dict"
)
local jieba_path = {
    dict_path = vim.fs.joinpath(dict_dir, "jieba.dict.utf8"),
    model_path = vim.fs.joinpath(dict_dir, "hmm_model.utf8"),
    user_dict_path = "/dev/null",
    idf_path = vim.fs.joinpath(dict_dir, "idf.utf8"),
    stop_word_path = vim.fs.joinpath(dict_dir, "stop_words.utf8"),
}

if vim.fn.has("win32") == 1 then
    jieba_path.user_dict_path = "nul"
end

---cut words
---@param str string
---@param hmm boolean
---@return string[]
local function cut(str, hmm)
    return require 'jieba'.cut(str, hmm, jieba_path)
end

return {
    cut = cut
}
