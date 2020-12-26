{ jdk, sbt, scala, ammonite, scalafmt, coursier, callPackage }:

let
  bloop = callPackage (builtins.fetchurl
    "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix")
    { };
in [ jdk sbt scala ammonite scalafmt coursier bloop ]
