{ stdenv, undmg, callPackage }:
let
  version = "1.39.6";
  sha256 = "0sayvjimxavd4c4h7n4i78rny4nk94cnlblwq90kw0ypfkx8garf";

in
callPackage ./mac-dmg-app.nix {
  name = "signal-desktop-mac-${version}";
  src = builtins.fetchurl {
    url =
      "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    inherit sha256;
  };
}
