{ pkgs, ... }:

let
  bloop = pkgs.callPackage (builtins.fetchurl
    "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix")
    { };
in {
  nixpkgs.overlays = let
    graalvm = self: super:
      let
        jre = pkgs.callPackage ../graalvm { };
        jdk = jre;
      in { inherit jre jdk; };
  in [ graalvm ];

  environment.systemPackages = with pkgs; [
    jdk
    sbt
    scala
    ammonite
    scalafmt
    coursier
    bloop
  ];

  environment.variables = { JAVA_HOME = "${pkgs.jdk}"; };
}
