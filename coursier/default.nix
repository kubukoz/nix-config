{ stdenv, coursier }:

let
  mkCoursierPackage = { name, version, artifact, alias ? name }: stdenv.mkDerivation {
    name = "${name}-${version}";
    buildInputs = [ coursier ];
    unpackPhase = "true";
    buildPhase = ''
      coursier bootstrap ${artifact} -o ${alias}
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ${alias} $out/bin/
    '';
  };

in
mkCoursierPackage
