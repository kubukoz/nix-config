{ pkgs, config, ... }:

let
  bloop = pkgs.callPackage (builtins.fetchurl
    "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix")
    { };
in {
  imports = [ ./sbt-module.nix ];

  home.packages = with pkgs; [ jdk sbt scala ammonite scalafmt coursier bloop ];
  home.sessionVariables = { JAVA_HOME = "${pkgs.jdk}"; };

  programs.sbt = {
    enable = true;
    plugins = [
      {
        org = "ch.epfl.scala";
        artifact = "sbt-bloop";
        version = "1.4.6";
      }
      {
        org = "net.virtual-void";
        artifact = "sbt-dependency-graph";
        version = "0.10.0-RC1";
      }
    ];

    credentials = let
      genericOcadoCredential = with config.secrets.ocado.nexus; {
        realm = "Sonatype Nexus Repository Manager";
        inherit user password;
      };

    in {
      "nexus.ocean.ocado.tech" = genericOcadoCredential;
      "ospcfc.nexus.ocado.tech" = genericOcadoCredential;
      "ocean.nexus.ocado.tech" = genericOcadoCredential;
    };
  };
}
