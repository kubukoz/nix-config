{ pkgs, ... }: {
  home.packages = [
    pkgs.awscli
    pkgs.ssm-session-manager-plugin
    (pkgs.callPackage ./ssm-helpers.nix { })
  ];
}
