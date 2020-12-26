{ callPackage }:
let
  node2nix = callPackage ./node2nix { };
  sbt-search =
    callPackage ./sbt-search.nix { mvn-search = node2nix."@erosb/mvn-search"; };

in [ sbt-search node2nix.fx ]
