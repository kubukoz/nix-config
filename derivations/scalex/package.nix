{ callPackage }:

let
  githubBinaryPackage = callPackage ../../lib/github-binary-package.nix { };
in
githubBinaryPackage {
  pname = "scalex";
  owner = "nguyenyou";
  repo = "scalex";
  sourcesFile = ./sources.json;
  description = "Scala code intelligence for coding agents";
  installCheckPhase = ''
    ($out/bin/scalex --help 2>&1 || true) | grep -q "Scala code intelligence"
  '';
}
