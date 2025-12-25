--- default config. See `lua vim.print(require"jieba.config")`.
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113
local fn = require 'vim.fn'

local dict_dir = fn.joinpath(
    fn.dirname(debug.getinfo(1).source:match("@?(.*)")),
    "dict"
)

return {
    --- if hmm is enabled
    hmm = true,
    --- config for paths
    paths = {
        dict_path = fn.joinpath(dict_dir, "jieba.dict.utf8"),      -- for dict
        model_path = fn.joinpath(dict_dir, "hmm_model.utf8"),      -- for model
        user_dict_path = fn.has_win32() and "nul" or "/dev/null",  -- for user dict
        idf_path = fn.joinpath(dict_dir, "idf.utf8"),              -- for idf
        stop_word_path = fn.joinpath(dict_dir, "stop_words.utf8"), -- for stop words
    }
}
