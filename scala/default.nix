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

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk}";
    JVM_DEBUG = "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";
  };

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

  home.file.".sbt/1.0/global.sbt".text = builtins.readFile ./global.sbt;
}
