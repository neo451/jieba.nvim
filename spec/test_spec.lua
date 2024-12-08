local paths = require "jieba.config".paths
local jieba = require("jieba").jieba(paths.dict_path,
    paths.model_path, paths.user_dict_path,
    paths.idf_path, paths.stop_word_path)

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests jieba:cut()", function()
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", true), 6)
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", false), 7)
    end)
end)
