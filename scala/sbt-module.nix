{ config, lib, ... }:

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

  cfg = config.programs.sbt;
  baseSbtConfigPath = ".sbt/1.0";
in {
  options.programs.sbt = {
    enable = mkEnableOption "sbt";

    plugins = mkOption {
      type = types.listOf (types.submodule {
        options = {
          org = mkOption { type = types.str; };
          artifact = mkOption { type = types.str; };
          version = mkOption { type = types.str; };
        };
      });
      default = [ ];
      apply = v: concatStrings (map renderPlugin v);
    };

    credentials = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          realm = mkOption { type = types.str; };
          user = mkOption { type = types.str; };
          password = mkOption { type = types.str; };
        };
      });
      default = [ ];
      apply = v: concatStrings (mapAttrsWithValues renderCredential v);
    };
  };

  config = mkIf cfg.enable {
    home.file."${baseSbtConfigPath}/plugins/plugins.sbt".text = cfg.plugins;
    home.file."${baseSbtConfigPath}/credentials.sbt".text = cfg.credentials;
  };
}
