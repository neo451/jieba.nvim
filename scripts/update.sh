#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

nix-shell --run 'luarocks install --force jieba.nvim'
