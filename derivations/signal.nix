{ callPackage }:
let
  version = "1.40.0";
in
callPackage ./mac-dmg-app.nix {
  name = "signal-desktop-mac-${version}";
  src = builtins.fetchurl {
    url =
      "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    sha256 = "170v63bmgyis4h5bs9dynzkvps620hngxbz70jsm75w8abvvksln";
  };
  passthru = {
    inherit version;
    mac-app = {
      label = "Signal";
      icon = "Signal.icns";
    };
  };
}
