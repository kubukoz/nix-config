{ pkgs, config, ... }:

let
  sources = import ../nix/sources.nix;
in
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
    (import sources.scala-cli { inherit pkgs; })
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk}";
    JVM_DEBUG = "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";
  };

  programs.sbt = {
    enable = true;
    plugins =
      let
        projectGraph = {
          org = "com.dwijnand";
          artifact = "sbt-project-graph";
          version = "0.4.0";
        };
      in
      [ projectGraph ];
    # credentials = [
    #   {
    #     realm = "Sonatype Nexus Repository Manager";
    #     host = "oss.sonatype.org";
    #     user = "kubukoz";
    #     passwordCommand = "cat ${toString ./secret-sonatype.txt}";
    #   }
    #   {
    #     realm = "Sonatype Nexus Repository Manager";
    #     host = "s01.oss.sonatype.org";
    #     user = "kubukoz";
    #     passwordCommand = "cat ${toString ./secret-sonatype.txt}";
    #   }
    # ];
  };

  home.file.".sbt/1.0/global.sbt".text = builtins.readFile
    ./global.sbt;
}
