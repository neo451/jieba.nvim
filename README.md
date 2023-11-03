# jieba.nvim

基于结巴中文分词的单词跳转，基于作者本人的[jieba-lua](https://github.com/noearc/jieba-lua)，插件逻辑来自[vim.jieba](https://github.com/kkew3/jieba.vim)

## 安装
lazy.nvim:
```
{'noearc/jieba.nvim', dependencies = {'noearc/jieba-lua'}},
```

## 设置
```
vim.keymap.set('n', 'B', ':lua require("jieba_nvim").wordmotion_B()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'b', ':lua require("jieba_nvim").wordmotion_b()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'w', ':lua require("jieba_nvim").wordmotion_w()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'W', ':lua require("jieba_nvim").wordmotion_W()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'E', ':lua require("jieba_nvim").wordmotion_E()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'e', ':lua require("jieba_nvim").wordmotion_e()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'ge', ':lua require("jieba_nvim").wordmotion_ge()<CR>', {noremap = false, silent = true})
vim.keymap.set('n', 'gE', ':lua require("jieba_nvim").wordmotion_gE()<CR>', {noremap = false, silent = true})
```
