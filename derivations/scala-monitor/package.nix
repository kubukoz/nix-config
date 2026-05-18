{
  callPackage,
  lib,
  stdenv,
  libidn2,
}:

let
  githubBinaryPackage = callPackage ../../lib/github-binary-package.nix { };
in
githubBinaryPackage {
  pname = "scala-monitor";
  owner = "polyvariant";
  repo = "scala-monitor";
  sourcesFile = ./sources.json;
  description = "Discover and monitor running Scala/JVM-related processes";
  extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin libidn2;
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change \
      /opt/homebrew/opt/libidn2/lib/libidn2.0.dylib \
      ${libidn2.out}/lib/libidn2.0.dylib \
      $out/bin/scala-monitor
  '';
  installCheckPhase = ''
    ($out/bin/scala-monitor --help 2>&1 || true) | grep -q "Output format"
  '';
}
