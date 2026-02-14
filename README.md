# jieba.nvim

[![readthedocs](https://shields.io/readthedocs/jieba-nvim)](https://jieba-nvim.readthedocs.io)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/neo451/jieba.nvim/main.svg)](https://results.pre-commit.ci/latest/github/neo451/jieba.nvim/main)
[![github/workflow](https://github.com/neo451/jieba.nvim/actions/workflows/main.yml/badge.svg)](https://github.com/neo451/jieba.nvim/actions)

[![github/downloads](https://shields.io/github/downloads/neo451/jieba.nvim/total)](https://github.com/neo451/jieba.nvim/releases)
[![github/downloads/latest](https://shields.io/github/downloads/neo451/jieba.nvim/latest/total)](https://github.com/neo451/jieba.nvim/releases/latest)
[![github/issues](https://shields.io/github/issues/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/discussions)
[![github/milestones](https://shields.io/github/milestones/all/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/milestones)
[![github/forks](https://shields.io/github/forks/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/network/members)
[![github/stars](https://shields.io/github/stars/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/stargazers)
[![github/watchers](https://shields.io/github/watchers/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/watchers)
[![github/contributors](https://shields.io/github/contributors/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/commits)
[![github/release-date](https://shields.io/github/release-date/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/releases/latest)

[![github/license](https://shields.io/github/license/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)
[![github/languages/top](https://shields.io/github/languages/top/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)
[![github/directory-file-count](https://shields.io/github/directory-file-count/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)
[![github/code-size](https://shields.io/github/languages/code-size/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)
[![github/repo-size](https://shields.io/github/repo-size/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)
[![github/v](https://shields.io/github/v/release/neo451/jieba.nvim)](https://github.com/neo451/jieba.nvim)

[![luarocks](https://img.shields.io/luarocks/v/freed-wu/jieba.nvim)](https://luarocks.org/modules/freed-wu/jieba.nvim)

![screencast](https://github.com/user-attachments/assets/bc133f6f-a11c-4013-9493-34f2347983f8)

This project provides:

- a lua binding for [cppjieba](https://github.com/yanyiwu/cppjieba)
- a neovim plugin for Chinese w/b/e/ge.

## Features

- [x] support count like `3w`.
- [x] flexibility. A
  [library](https://github.com/neo451/jieba.nvim/tree/main/packages/wordmotion.nvim)
  is provided. Even you can realize a w/b/e/gw according to LLM's tokenize
  algorithm.
- [x] better performance than pure lua thank to cppjieba.
- [ ] [jieba-rs](https://github.com/messense/jieba-rs) is faster than cppjieba.
  Perhaps we can use it to create `rjieba.nvim`.
- [ ] text object `iw` and `dw`, `cw`, ...

## Related Projects

- [coc-ci](https://github.com/fannheyward/coc-ci): based on
  [segmentit](https://github.com/linonetwo/segmentit). Written in nodejs.
- [jieba-lua](https://github.com/neo451/jieba-lua): written in lua.
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
    { "neo451/jieba.nvim", lazy = false },
  },
}
```

## Binding

```lua
local Jieba = require "jieba.jieba".Jieba
local jieba = Jieba()
local tokens = jieba:cut "他来到了网易杭研大厦"
print(tokens[#tokens])
-- 大厦
```

## Plugin

### Dictionary

By default, it doesn't use any user dictionary. You can:

```lua
local Jieba = require "jieba.jieba".Jieba
local Motion = require "wordmotion.jieba".Motion
local motion = Motion {
    jieba = Jieba {
        paths = {
            user_dict = "/the/path/of/my/user.dict.utf8"
        }
    }
}
motion:set_keymaps()
```

### HMM

HMM can provide higher precision. You can disable it by:

```lua
local motion = Motion {
    jieba = Jieba {
        hmm = false,
    }
}
```
