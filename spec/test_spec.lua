package.path = package.path .. ';lua/?.lua'

local jieba = require "jieba.jieba".Jieba()
local fs = require 'vim.fs'
local txt = fs.joinpath(fs.dirname(debug.getinfo(1).source:match("@?(.*)")), "test.txt")

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests jieba:cut()", function()
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", true), 6)
        assert.are.equal(#jieba:cut("他来到了网易杭研大厦", false), 7)
    end)
end)

describe("test b/e/w/ge", function()
    local Cursor = require "wordmotion.jieba".Cursor
    local cursor = Cursor:from_path(txt)
    it("tests b", function()
        local pos = cursor:get_position(1, true, { 2, 0 })
        assert.are.equal(pos[1], 2)
        assert.are.equal(pos[2], 6)
    end)
    it("tests e", function()
        local pos = cursor:get_position(1, false, { 2, 0 })
        assert.are.equal(pos[1], 2)
        assert.are.equal(pos[2], 3)
    end)
end)
