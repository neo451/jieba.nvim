---wrap `require'jieba'.Jieba`
local Jieba = require 'jieba'.Jieba
local fn = require 'vim.fn'
local dict_dir = fn.joinpath(
    fn.dirname(debug.getinfo(1).source:match("@?(.*)")),
    "dict"
)
local M = {
    Jieba = {
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
}

---@param jieba table?
---@return table? jieba
---@see ime.new
function M.Jieba:new(jieba)
    jieba = jieba or {}
    setmetatable(jieba, {
        __index = self
    })

    for _, path in pairs(jieba.paths) do
        local f = io.open(path)
        if f == nil then
            return nil
        end
        f:close()
    end
    jieba.jieba = Jieba(jieba.paths.dict_path,
        jieba.paths.model_path, jieba.paths.user_dict_path,
        jieba.paths.idf_path, jieba.paths.stop_word_path)
    return jieba
end

setmetatable(M.Jieba, {
    __call = M.Jieba.new
})

---cut string
---@param str string
---@return string[]
function M.Jieba:cut(str)
    return self.jieba:cut(str, self.hmm)
end

return M
