{ pkgs ? import <nixpkgs> { } }:
let
  blp = builtins.fetchurl
    "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix";
in pkgs.callPackage blp { }
