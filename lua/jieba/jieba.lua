---wrap `require'jieba'.Jieba`
local Jieba = require 'jieba'.jieba
local fn = require 'vim.fn'
local fs = require 'vim.fs'
local dict_dir = fs.joinpath(
    fs.dirname(debug.getinfo(1).source:match("@?(.*)")),
    "dict"
)
local M = {
    Jieba = {
        --- if hmm is enabled
        hmm = true,
        --- config for paths
        paths = {
            dict_path = fs.joinpath(dict_dir, "jieba.dict.utf8"),      -- for dict
            model_path = fs.joinpath(dict_dir, "hmm_model.utf8"),      -- for model
            user_dict_path = fn.has 'win32' == 1 and "nul" or "/dev/null",  -- for user dict
            idf_path = fs.joinpath(dict_dir, "idf.utf8"),              -- for idf
            stop_word_path = fs.joinpath(dict_dir, "stop_words.utf8"), -- for stop words
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
            print(path .. " doesn't exist!")
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
---@param hmm boolean?
---@return string[]
function M.Jieba:cut(str, hmm)
    if hmm == nil then
        hmm = self.hmm
    end
    return self.jieba:cut(str, hmm)
end

return M
