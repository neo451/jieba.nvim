# jieba.nvim

基于结巴中文分词的单词跳转，基于[jieba-lua](https://github.com/noearc/jieba-lua), 好处是比原版 jieba 快, 但并不会比采用 cppjieba 的 jieba.nvim 快, 不过完全够用, 且不需要本地编译，插件逻辑来自[jieba.vim](https://github.com/kkew3/jieba.vim)

## 安装

lazy.nvim:

```
{'noearc/jieba.nvim', dependencies = {'noearc/jieba-lua'}, opts = {} },
```

## 设置

默认 keymap, 强化了 neovim 的 b, w, e, ge, 暂无数字修饰

```lua
vim.keymap.set({'x', 'n'}, 'B', '<cmd>lua require("jieba_nvim").wordmotion_B()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'b', '<cmd>lua require("jieba_nvim").wordmotion_b()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'w', '<cmd>lua require("jieba_nvim").wordmotion_w()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'W', '<cmd>lua require("jieba_nvim").wordmotion_W()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'E', '<cmd>lua require("jieba_nvim").wordmotion_E()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'e', '<cmd>lua require("jieba_nvim").wordmotion_e()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'ge', '<cmd>lua require("jieba_nvim").wordmotion_ge()<CR>', {noremap = false, silent = true})
vim.keymap.set({'x', 'n'}, 'gE', '<cmd>lua require("jieba_nvim").wordmotion_gE()<CR>', {noremap = false, silent = true})
```

可选 keymap, 模拟了 neovim 的 text object w, 可调用以下三个函数, 具体 keymap 可根据偏好自行添加

```lua
vim.keymap.set('n', 'ce', ":lua require'jieba_nvim'.change_w()<CR>", {noremap = false, silent = true})
vim.keymap.set('n', 'de', ":lua require'jieba_nvim'.delete_w()<CR>",  {noremap = false, silent = true})
vim.keymap.set('n', '<leader>w' , ":lua require'jieba_nvim'.select_w()<CR>", {noremap = false, silent = true})
```
