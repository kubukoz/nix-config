{ stdenv, coursier }:

{
  coursierBootstrap = { name, version, artifact, alias ? name }:
    stdenv.mkDerivation {
      name = "${name}-${version}";
      buildInputs = [ coursier ];
      unpackPhase = "true";
      COURSIER_JVM_CACHE = ".nix/COURSIER_JVM_CACHE";
      COURSIER_CACHE = ".nix/COURSIER_CACHE";
      COURSIER_ARCHIVE_CACHE = ".nix/COURSIER_ARCHIVE_CACHE";
      buildPhase = ''
        cs bootstrap ${artifact} -o ${alias}
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp ${alias} $out/bin/
      '';
    };
}
