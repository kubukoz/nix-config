{ pkgs, config, ... }:

{
  imports = [ ./bloop.nix ];

  home.packages = with pkgs; [
    jdk
    scala
    ammonite
    scalafmt
    coursier
    (callPackage ../coursier/spotify-next.nix {})
    (callPackage ../coursier/giter8.nix {})
    (callPackage ../coursier/scalafix.nix {})
    (callPackage ../coursier/catscript.nix {})
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
    credentials = [
      {
        realm = "Sonatype Nexus Repository Manager";
        host = "oss.sonatype.org";
        user = "kubukoz";
        passwordCommand = "cat ${toString ./secret-sonatype.txt}";
      }
    ];
  };

  home.file.".sbt/1.0/global.sbt".text = builtins.readFile
    ./global.sbt;
}
