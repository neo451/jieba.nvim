-- luacheck: ignore 112 113
---@diagnostic disable: undefined-global
local dict_dir = vim.fs.joinpath(
    vim.fs.dirname(vim.fs.dirname(debug.getinfo(1).source:match("@?(.*)"))),
    "dict"
)

return {
    hmm = true,
    paths = {
        dict_path = vim.fs.joinpath(dict_dir, "jieba.dict.utf8"),
        model_path = vim.fs.joinpath(dict_dir, "hmm_model.utf8"),
        user_dict_path = vim.fn.has("win32") == 0 and "/dev/null" or "nul",
        idf_path = vim.fs.joinpath(dict_dir, "idf.utf8"),
        stop_word_path = vim.fs.joinpath(dict_dir, "stop_words.utf8"),
    }
}
