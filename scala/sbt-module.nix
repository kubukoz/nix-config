{ config, lib, pkgs, ... }:

with lib;

let
  renderPlugin = plugin: ''
    addSbtPlugin("${plugin.org}" % "${plugin.artifact}" % "${plugin.version}")
  '';
  renderPlugins = plugins: concatStrings (map renderPlugin plugins);

  renderCredential = host: cred: ''
    credentials += Credentials("${cred.realm}", "${host}", "${cred.user}", "${cred.password}")
  '';

  sbtTypes = {
    plugin = types.submodule {
      options = {
        org = mkOption { type = types.str; };
        artifact = mkOption { type = types.str; };
        version = mkOption { type = types.str; };
      };
    };

    credential = types.submodule {
      options = {
        realm = mkOption { type = types.str; };
        user = mkOption { type = types.str; };
        password = mkOption { type = types.str; };
      };
    };
  };

  cfg = config.programs.sbt;
in {
  options.programs.sbt = {
    enable = mkEnableOption "sbt";

    package = mkOption {
      type = types.package;
      default = pkgs.sbt;
      description = "The package with sbt to be installed";
    };

    baseConfigPath = mkOption {
      type = types.str;
      default = ".sbt/1.0";
      description = "Where the plugins and credentials should be located";
    };

    plugins = mkOption {
      type = types.attrsOf (types.listOf (sbtTypes.plugin));
      default = { };
      description = ''
        A map of file names to lists of plugins to place in the directories.
        All the files will be placed under ''${sbt.programs.baseConfigPath}/plugins.'';
      example = {
        "plugins.sbt" = [{
          org = "net.virtual-void";
          artifact = "sbt-dependency-graph";
          version = "0.10.0-RC1";
        }];
      };
      apply = mapAttrs (_: renderPlugins);
    };

    credentials = mkOption {
      type = types.attrsOf (sbtTypes.credential);
      default = { };
      description =
        "A list of credentials to define in the sbt configuration directory";
      example = {
        "example.com" = {
          realm = "Sonatype Nexus Repository Manager";
          user = "user";
          password = "password";
        };
      };
      apply = v: concatStrings (mapAttrsToList renderCredential v);
    };
  };

  config = let

  in mkIf cfg.enable (mkMerge [
    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.plugins != { }) {
      home.file = mkMerge (mapAttrsToList (filename: plugins: {
        "${cfg.baseConfigPath}/plugins/${filename}".text = plugins;
      }) cfg.plugins);
    })

    (mkIf (cfg.credentials != "") {
      home.file."${cfg.baseConfigPath}/credentials.sbt".text = cfg.credentials;
    })
  ]);
}
