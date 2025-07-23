if require("jieba.nvim") == nil then
    return
end
-- luacheck: ignore 112 113
---@diagnostic disable: undefined-global
vim.keymap.set("n", "b", function()
    require("jieba.nvim").wordmotion_b()
end, { noremap = false, silent = true })
vim.keymap.set("n", "w", function()
    require("jieba.nvim").wordmotion_w()
end, { noremap = false, silent = true })
vim.keymap.set("n", "e", function()
    require("jieba.nvim").wordmotion_e()
end, { noremap = false, silent = true })
vim.keymap.set("n", "ge", function()
    require("jieba.nvim").wordmotion_ge()
end, { noremap = false, silent = true })
