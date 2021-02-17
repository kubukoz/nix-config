{ callPackage }:
let
  version = "85.0.2";
  language = "en-GB";
in
callPackage ./mac-dmg-app.nix {
  name = "firefox-mac-${version}";
  src = builtins.fetchurl {
    name = "firefox-sources-${version}";
    url =
      "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/${language}/Firefox%20${version}.dmg";
    sha256 = "1iqpvqh8n47j81xq6qqq1pcd1vv5d98ahad8ab45a43d6fc2spyr";
  };
  passthru = {
    inherit version;
    mac-app = {
      label = "Firefox";
      icon = "firefox.icns";
    };
  };
}
