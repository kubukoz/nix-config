{ pkgs, config, ... }:
let vpn = pkgs.callPackage ./vpn.nix { inherit config; };
in { home.packages = [ pkgs.openconnect vpn ]; }
