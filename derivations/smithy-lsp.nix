{ stdenv, makeWrapper, setJavaClassPath, jre, lib, coursier }:

let
  pname = "smithy-language-server";
  version = "0.7.0";
in stdenv.mkDerivation rec {
  inherit pname version;

  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch software.amazon.smithy:smithy-language-server:${version} > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-pi7tPAhKTJ2KEUgBQRFQlMItqd4K9lYXwNxYSVSY9/Y=";
  };

  nativeBuildInputs = [ makeWrapper setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --add-flags "${extraJavaOpts} -cp $CLASSPATH software.amazon.smithy.lsp.Main"
  '';

  meta = with lib; {
    homepage = "https://github.com/smithy-lang/smithy-language-server";
    license = licenses.asl20;
    description = "Language server for smithy";
    maintainers = [ ];
  };
}
