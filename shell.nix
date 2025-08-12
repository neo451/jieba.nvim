{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "jieba.nvim";
  buildInputs = [
    pkg-config
    xmake
    cmake
    ninja

    (luajit.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
