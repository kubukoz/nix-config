{ callPackage }:
let
  version = "1.40.1";
in
callPackage ./mac-dmg-app.nix {
  name = "signal-desktop-mac-${version}";
  src = builtins.fetchurl {
    url =
      "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    sha256 = "0xk5gsxlc6imlp5lpkwv1416ryn297sar9hm4xrp4ikvkwn15f1z";
  };
  passthru = {
    inherit version;
    mac-app = {
      label = "Signal";
      icon = "Signal.icns";
    };
  };
}
