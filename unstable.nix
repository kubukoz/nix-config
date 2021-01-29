{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "nixos";
  repo = "nixpkgs";
  rev = "552d7182874ef1b8fcf25c55d3777719a5ec7bfb";
  sha256 = "1v1ds70rcadpi20l6cbjkpbhwnpw6b83ws6nbqs7f1v3yci1saw1";
}
