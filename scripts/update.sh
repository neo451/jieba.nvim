#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

nix-shell --run 'luarocks --lua-version=5.1 install --force --local jieba.nvim'
