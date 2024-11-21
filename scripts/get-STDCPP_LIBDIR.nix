#!/usr/bin/env -S nix eval --impure -f
"${(import <nixpkgs> {}).stdenv.cc.cc.lib}/lib"
