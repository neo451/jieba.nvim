# jieba.nvim

[![readthedocs](https://shields.io/readthedocs/jieba-nvim)](https://jieba-nvim.readthedocs.io)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Freed-Wu/jieba.nvim/main.svg)](https://results.pre-commit.ci/latest/github/Freed-Wu/jieba.nvim/main)
[![github/workflow](https://github.com/Freed-Wu/jieba.nvim/actions/workflows/main.yml/badge.svg)](https://github.com/Freed-Wu/jieba.nvim/actions)

[![github/downloads](https://shields.io/github/downloads/Freed-Wu/jieba.nvim/total)](https://github.com/Freed-Wu/jieba.nvim/releases)
[![github/downloads/latest](https://shields.io/github/downloads/Freed-Wu/jieba.nvim/latest/total)](https://github.com/Freed-Wu/jieba.nvim/releases/latest)
[![github/issues](https://shields.io/github/issues/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/discussions)
[![github/milestones](https://shields.io/github/milestones/all/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/milestones)
[![github/forks](https://shields.io/github/forks/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/network/members)
[![github/stars](https://shields.io/github/stars/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/stargazers)
[![github/watchers](https://shields.io/github/watchers/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/watchers)
[![github/contributors](https://shields.io/github/contributors/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/commits)
[![github/release-date](https://shields.io/github/release-date/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/releases/latest)

[![github/license](https://shields.io/github/license/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)
[![github/languages/top](https://shields.io/github/languages/top/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)
[![github/directory-file-count](https://shields.io/github/directory-file-count/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)
[![github/code-size](https://shields.io/github/languages/code-size/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)
[![github/repo-size](https://shields.io/github/repo-size/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)
[![github/v](https://shields.io/github/v/release/Freed-Wu/jieba.nvim)](https://github.com/Freed-Wu/jieba.nvim)

[![luarocks](https://img.shields.io/luarocks/v/Freed-Wu/jieba.nvim)](https://luarocks.org/modules/Freed-Wu/jieba.nvim)

Use C/C++ to realize Chinese w/b/e/ge for neovim.

## Related Projects

- [coc-ci](https://github.com/fannheyward/coc-ci): based on
  [segmentit](https://github.com/linonetwo/segmentit). Written in nodejs.
- [jieba.nvim](https://github.com/neo451/jieba.nvim): based on
  [jieba-lua](https://github.com/neo451/jieba-lua). Written in lua.
- [jieba.vim](https://github.com/kkew3/jieba.vim): based on
  [jieba-rs](https://github.com/messense/jieba-rs)
  Written in python and rust.
- [jieba_nvim](https://github.com/cathaysia/jieba_nvim): based on
  [cppjieba](https://github.com/yanyiwu/cppjieba). Written in C++. Stop
  maintenance. This project is a rewrite of it.

## Similar Projects

- [deno-bridge-jieba](https://github.com/ginqi7/deno-bridge-jieba): based on
  [deno-jieba](https://github.com/wangbinyq/deno-jieba). Written in denojs use
  and wasm.
- [vscode-jieba](https://github.com/stephanoskomnenos/vscode-jieba): based on
  [jieba-rs](https://github.com/messense/jieba-rs). Written in rust and use
  wasm. Support Vim mode and Emacs mode.

## Install

### rocks.nvim

#### Command style

```vim
:Rocks install jieba.nvim
```

#### Declare style

`~/.config/nvim/rocks.toml`:

```toml
[plugins]
"jieba.nvim" = "scm"
```

Then

```vim
:Rocks sync
```

or:

```sh
$ luarocks --lua-version 5.1 --local --tree ~/.local/share/nvim/rocks install jieba.nvim
# ~/.local/share/nvim/rocks is the default rocks tree path
# you can change it according to your vim.g.rocks_nvim.rocks_path
```

### lazy.nvim

```lua
require("lazy").setup {
  spec = {
    { "Freed-Wu/jieba.nvim", lazy = false },
  },
}
```

## Configure

### Keymap

Be default, add keymaps for b/B/w/W/e/E/ge/gE. you can enable more:

```lua
vim.keymap.set("n", "ce", function()
    require("jieba.nvim").wordmotion_change_w()
end, { noremap = false, silent = true })
vim.keymap.set("n", "de", function()
    require("jieba.nvim").wordmotion_delete_w()
end, { noremap = false, silent = true })
vim.keymap.set("n", "viw", function()
    require("jieba.nvim").wordmotion_select_w()
end, { noremap = false, silent = true })
```

### Dictionary

By default, it doesn't use any user dictionary. You can:

```lua
require"jieba.jieba".Jieba.paths.user_dict_path = "/the/path/of/my/user.dict.utf8"
```

### HMM

HMM can provide higher precision. You can disable it by:

```lua
require"jieba.jieba".Jieba.hmm = false
```

## TODO

- [rust-jieba](https://github.com/messense/rust-jieba) is faster than cppjieba.
  Perhaps we can use it as new backend.
- [decouple](https://github.com/neo451/jieba.nvim/issues/10) jieba's backend and
  frontend
