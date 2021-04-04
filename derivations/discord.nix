{ callPackage }:
let
  version = "0.0.262";
in
callPackage ./mac-dmg-app.nix {
  name = "discord-mac-${version}";
  src = builtins.fetchurl {
    url =
      "https://cdn.discordapp.com/apps/osx/${version}/Discord.dmg";
    sha256 = "03iws3g2m8rpmpmavp5ais0h1wbdknjiv7pxnmj3dqjig4xm0jab";
  };

  passthru = {
    inherit version;
    mac-app = {
      label = "Discord";
      icon = "electron.icns";
    };
  };
}
