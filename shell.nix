{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  name = "jieba.nvim";
  buildInputs = [
    pkg-config
    luajit
    xmake
    stdenv.cc
  ];
  # https://github.com/NixOS/nixpkgs/issues/314313#issuecomment-2134252094
  shellHook = ''
    LD="$CC"
  '';
}
