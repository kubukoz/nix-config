{ name
, src
, passthru ? {}
, stdenv
, undmg
}:

stdenv.mkDerivation {
  inherit name src passthru;
  buildInputs = [ undmg ];
  unpackPhase = ''
    mkdir temp;
    (cd temp; undmg $src;)
    cp -R temp/*.app .'';

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications"
  '';
}
