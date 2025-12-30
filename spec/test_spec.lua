package.path = package.path .. ';lua/?.lua'

local jieba = require "jieba.jieba".Jieba()

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests jieba:cut()", function()
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", true), 6)
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", false), 7)
    end)
end)
