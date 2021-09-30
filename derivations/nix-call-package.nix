# nix-callpackage
{ writeScriptBin }:

writeScriptBin
  "nix-call-package"
  "nix-build --expr '(import <nixpkgs> {}).callPackage ./. {}'"
