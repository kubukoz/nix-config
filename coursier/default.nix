{ stdenv, coursier, jre, makeWrapper, lib }:

{
  coursierBootstrap = { pname, version, artifact, alias ? pname, mainClass
    , sha256, buildInputs ? [ ], ... }@args':
    let
      deps = stdenv.mkDerivation {
        pname = "${pname}-deps";
        inherit version;
        dontUnpack = true;

        buildInputs = [ coursier ];

        COURSIER_CACHE = ".nix/COURSIER_CACHE";
        buildCommand = ''
          cs fetch ${artifact} > deps
          mkdir -p $out/share/java
          cp $(< deps) $out/share/java/
        '';

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = sha256;
      };

      argsBuildInputs = buildInputs;
      extraArgs = builtins.removeAttrs args' [
        "pname"
        "version"
        "artifact"
        "alias"
        "mainClass"
        "sha256"
        "buildInputs"
      ];
      baseArgs = {
        inherit pname version;
        buildInputs = [ jre deps ] ++ argsBuildInputs;
        nativeBuildInputs = [ makeWrapper ];

        buildCommand = ''
          makeWrapper ${jre}/bin/java $out/bin/${alias} \
            --add-flags "-cp $CLASSPATH ${mainClass}"

          runHook postInstall
        '';
      };
    in stdenv.mkDerivation (baseArgs // extraArgs);
}
