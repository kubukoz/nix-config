{ pkgs, ... }:
let
  bloop = pkgs.callPackage (builtins.fetchurl
    "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix")
    { };
in {
  home.packages = [ bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      version = "1.4.6";
    }];
  };
}
