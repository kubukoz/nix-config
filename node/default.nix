{ pkgs, ... }:
let
  node2nix = pkgs.callPackage ./node2nix {};
  sbt-search = pkgs.callPackage ./sbt-search.nix {
    mvn-search = node2nix."@erosb/mvn-search";
  };
  localPackages = [ sbt-search node2nix.fx node2nix.asciicast2gif ];
in
{
  # might need to ignore localPackages on fresh machines / after new packages are added.
  # make sure to run node2nix first
  home.packages = [ pkgs.nodePackages.node2nix ] ++ localPackages;
}
