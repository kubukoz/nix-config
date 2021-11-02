{ pkgs, ... }:
let
  node2nix = pkgs.callPackage ./node2nix {};
  localPackages = [];
in
{
  home.packages = [ pkgs.nodePackages.node2nix ] ++ localPackages;
}
