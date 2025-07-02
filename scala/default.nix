{ pkgs, config, machine, ... }:

{
  imports = [ ./bloop.nix ];

  home.packages = with pkgs; [
    jdk
    scala
    ammonite
    scalafmt
    coursier
    (callPackage ../derivations/spotify-next.nix { })
    (callPackage ../coursier/giter8.nix { })
    scala-cli
    sbt
  ];

  home.sessionVariables = {
    JVM_DEBUG =
      "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005";
    # configured to make it easier to enter this directory
    # but the actual value is the same as the default
    COURSIER_CACHE = "${machine.homedir}/Library/Caches/Coursier/v1";
  };

  programs.java.enable = true;

  programs.sbt = {
    enable = true;
    # plugins =
    #   let
    #     projectGraph = {
    #       org = "com.dwijnand";
    #       artifact = "sbt-project-graph";
    #       version = "0.4.0";
    #     };
    #   in
    #   [ projectGraph ];
    credentials = [
      {
        realm = "Sonatype Nexus Repository Manager";
        host = "oss.sonatype.org";
        user = "+zPBmWrk";
        passwordCommand = "cat ${machine.homedir}/secrets/sonatype.txt";
      }
      {
        realm = "Sonatype Nexus Repository Manager";
        host = "s01.oss.sonatype.org";
        user = "ofcQe0gV";
        passwordCommand = "cat ${machine.homedir}/secrets/sonatype-s01.txt";
      }
      {
        realm = "Sonatype Central";
        host = "central.sonatype.org";
        user = "SAc7aklX";
        passwordCommand = "cat ${machine.homedir}/secrets/sonatype-central.txt";
      }
    ];
  };

  home.file.".sbt/1.0/global.sbt".text = builtins.readFile ./global.sbt;
}
