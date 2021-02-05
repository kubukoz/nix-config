{ pkgs, config, ... }:

let
  nix-dss = import (builtins.fetchGit {
    url = "git@github.bamtech.co:jkozlowski/nix-dss";
    ref = "v0.0.5";
    rev = "6557306249078fc8f0f41f30821bb45ef3e0dc4c";
  }) { inherit pkgs; };
in {
  home.packages = [
    pkgs.awscli
    pkgs.ssm-session-manager-plugin
    (pkgs.callPackage ./ssm-helpers.nix { })
    nix-dss.bamc
  ];

  home.file.".aws/credentials".source =
    config.lib.file.mkOutOfStoreSymlink ./secret-credentials;
}
