{ pkgs, config, ... }:

{
  imports = [ ./sbt-module.nix ./bloop.nix ];

  home.packages = with pkgs; [
    jdk
    scala
    ammonite
    scalafmt
    coursier
    # (callPackage ./fury.nix { })
  ];

  home.sessionVariables = { JAVA_HOME = "${pkgs.jdk}"; };

  programs.sbt = {
    enable = true;
    plugins = [{
      org = "net.virtual-void";
      artifact = "sbt-dependency-graph";
      version = "0.10.0-RC1";
    }];
  };
}
