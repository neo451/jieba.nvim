#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

eval "nix-shell --run luarocks install --lua-version 5.1 --local --force jieba.nvim STDCPP_LIBDIR=$(scripts/get-STDCPP_LIBDIR.nix)"
