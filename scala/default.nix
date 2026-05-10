{
  pkgs,
  config,
  machine,
  ...
}:

let
  sbt-publish-snapshot = pkgs.writeShellApplication {
    name = "sbt-publish-snapshot";
    runtimeInputs = [ pkgs.sbt pkgs.git ];
    text = ''
      set -euo pipefail

      ORG="com.kubukoz"
      BASE_VERSION="''${BASE_VERSION:-0.0.0}"
      VERSION="''${BASE_VERSION}-kubukoz.$(git rev-parse --short HEAD)-SNAPSHOT"

      sbt \
        "set ThisBuild / organization := \"$ORG\"" \
        "set ThisBuild / organizationName := \"kubukoz\"" \
        "set ThisBuild / version := \"$VERSION\"" \
        "set ThisBuild / tlMimaPreviousVersions := Set.empty" \
        "set ThisBuild / tlFatalWarnings := false" \
        "+publish"
    '';
  };
in
{
  imports = [ ./bloop.nix ];

  home.packages = with pkgs; [
    jdk
    scala
    ammonite
    scalafmt
    coursier
    scala-cli
    sbt
    sbt-publish-snapshot
  ];

  home.sessionVariables = {
    JVM_DEBUG = "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005";
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
        realm = "Sonatype Nexus Repository Manager";
        host = "central.sonatype.com";
        user = "v3uZaOIU";
        passwordCommand = "cat ${machine.homedir}/secrets/sonatype-central.txt";
      }
    ];
  };

  home.file.".sbt/1.0/global.sbt".text = builtins.readFile ./global.sbt;
}
