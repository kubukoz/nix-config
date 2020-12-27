{ config, lib, ... }:

with lib;

let
  cfg = config.programs.sbt;
  mapAttrsZipped = f2: attrs:
    let keys = attrNames attrs;
    in map (k: f2 k (attrs."${k}")) keys;

  makePlugin = plugin:
    ''
      addSbtPlugin("${plugin.org}" % "${plugin.artifact}" % "${plugin.version}")'';

  makeCredential = host: cred:
    ''
      credentials += Credentials("${cred.realm}", "${host}", "${cred.user}", "${cred.password}")'';

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
  baseSbtConfigPath = ".sbt/1.0";
in {
  options.programs.sbt = {
    enable = mkEnableOption "sbt";

    plugins = mkOption {
      type = types.listOf plugin;
      default = [ ];
    };
    credentials = mkOption {
      type = types.attrsOf credential;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {

    home.file."${baseSbtConfigPath}/plugins/plugins.sbt".text =
      concatStringsSep "\n" (map makePlugin cfg.plugins);

    home.file."${baseSbtConfigPath}/credentials.sbt".text =
      concatStringsSep "\n" (mapAttrsZipped makeCredential cfg.credentials);
  };
}
