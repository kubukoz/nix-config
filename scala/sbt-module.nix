{ config, lib, pkgs, ... }:

with lib;

let
  mapAttrsWithValues = f2: attrs:
    map (k: f2 k (attrs."${k}")) (attrNames attrs);

  renderPlugin = plugin: ''
    addSbtPlugin("${plugin.org}" % "${plugin.artifact}" % "${plugin.version}")
  '';

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
    };

    baseConfigPath = mkOption {
      type = types.str;
      default = ".sbt/1.0";
    };

    plugins = mkOption {
      type = types.listOf (sbtTypes.plugin);
      default = [ ];
      apply = v: concatStrings (map renderPlugin v);
    };

    credentials = mkOption {
      type = types.attrsOf (sbtTypes.credential);
      default = { };
      apply = v: concatStrings (mapAttrsWithValues renderCredential v);
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.plugins != "") {
      home.file."${cfg.baseConfigPath}/plugins/plugins.sbt".text = cfg.plugins;
    })

    (mkIf (cfg.credentials != "") {
      home.file."${cfg.baseConfigPath}/credentials.sbt".text = cfg.credentials;
    })
  ]);
}
