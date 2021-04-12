{ callPackage }:
let
  version = "5.0.0";
in
callPackage ./mac-dmg-app.nix {
  name = "signal-desktop-mac-${version}";
  src = builtins.fetchurl {
    url =
      "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    sha256 = "09ag5mmpx7vqz5dg2fd89sgj6y89q4kin7rnn5zjsbyig6m6xp0y";
  };
  passthru = {
    inherit version;
    mac-app = {
      label = "Signal";
      icon = "Signal.icns";
    };
  };
}
