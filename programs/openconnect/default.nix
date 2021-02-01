{ pkgs, ... }:
let vpn = pkgs.callPackage ./vpn.nix { };
in { home.packages = [ pkgs.openconnect vpn ]; }
