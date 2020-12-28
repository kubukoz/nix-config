{ pkgs, config, ... }:

{
  imports = [ ./sbt-module.nix ./bloop.nix ];

  home.packages = with pkgs; [ jdk sbt scala ammonite scalafmt coursier ];
  home.sessionVariables = { JAVA_HOME = "${pkgs.jdk}"; };

  programs.sbt = {
    enable = true;
    plugins = [{
      org = "net.virtual-void";
      artifact = "sbt-dependency-graph";
      version = "0.10.0-RC1";
    }];

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
