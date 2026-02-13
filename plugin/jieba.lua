---plugin. load dictionary is slow
---@diagnostic disable: undefined-global
-- luacheck: ignore 112 113
vim.schedule(
    function()
        require 'jieba.nvim'.init()
    end
)
require 'jieba.nvim'.set_keymaps()
