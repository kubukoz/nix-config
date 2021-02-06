{ pkgs, config, ... }:

{
  imports = [ ./bloop.nix ];

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
    plugins =
      let
        dependencyGraph = {
          org = "net.virtual-void";
          artifact = "sbt-dependency-graph";
          version = "0.10.0-RC1";
        };
        projectGraph = {
          org = "com.dwijnand";
          artifact = "sbt-project-graph";
          version = "0.4.0";
        };
      in
      [ dependencyGraph projectGraph ];
  };
}
