{ stdenv, coursier, jre, makeWrapper }:

{
  coursierBootstrap = { name, version, artifact, alias ? name }:
    stdenv.mkDerivation {
      name = "${name}-${version}";
      buildInputs = [ coursier ];
      unpackPhase = "true";
      # todo: technically these aren't used anymore once we have the bootstrap.
      # Something should be done to change the coursier cache of the runtime.
      COURSIER_JVM_CACHE = ".nix/COURSIER_JVM_CACHE";
      COURSIER_CACHE = ".nix/COURSIER_CACHE";
      COURSIER_ARCHIVE_CACHE = ".nix/COURSIER_ARCHIVE_CACHE";
      buildPhase = ''
        cs bootstrap ${artifact} -o ${alias}
      '';
      nativeBuildInputs = [ makeWrapper ];
      propagatedBuildInputs = [ jre ];

      installPhase = ''
        mkdir -p $out/bin
        cp -r .nix $out/lib
        cp ${alias} $out/lib/
        # todo: do the same for all 3 cache dirs?
        makeWrapper "$out/lib/${alias}" "$out/bin/${alias}" --set COURSIER_CACHE "$out/lib/COURSIER_CACHE"
      '';
    };
}
