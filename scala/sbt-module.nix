{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.sbt;
  makePlugin = plugin:
    ''
      addSbtPlugin("${plugin.org}" % "${plugin.artifact}" % "${plugin.version}")'';
  pluginsText = concatStringsSep "\n" (map makePlugin cfg.plugins);
  plugin = types.submodule {
    options = {
      org = mkOption { type = types.str; };
      artifact = mkOption { type = types.str; };
      version = mkOption { type = types.str; };
    };
  };
in {
  options.programs.sbt = {
    enable = mkEnableOption "sbt";

    plugins = mkOption { type = types.listOf plugin; };
  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.gnupg ];

    home.file.".sbt/1.0/plugins/plugins.sbt".text = pluginsText;
  };
}
