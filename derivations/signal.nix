{ stdenv, undmg }:
let
  version = "1.39.6";
  sha256 = "0sayvjimxavd4c4h7n4i78rny4nk94cnlblwq90kw0ypfkx8garf";

in stdenv.mkDerivation {
  name = "signal-desktop-mac-${version}";
  buildInputs = [ undmg ];
  src = builtins.fetchurl {
    url =
      "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    inherit sha256;
  };
  unpackPhase = ''
    mkdir temp;
    (cd temp; undmg $src;)
    cp -R temp/Signal.app/* .'';

  installPhase = ''
    mkdir -p "$out/Applications/Signal.app"
    cp -R . "$out/Applications/Signal.app"
    chmod u+x "$out/Applications/Signal.app/Contents/MacOS/Signal"
  '';
}
