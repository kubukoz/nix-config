{ callPackage }:

let
  githubBinaryPackage = callPackage ../../lib/github-binary-package.nix { };
in
githubBinaryPackage {
  pname = "scala-monitor";
  owner = "polyvariant";
  repo = "scala-monitor";
  sourcesFile = ./sources.json;
  description = "Discover and monitor running Scala/JVM-related processes";
  installCheckPhase = ''
    ($out/bin/scala-monitor --help 2>&1 || true) | grep -q "Output format"
  '';
}
