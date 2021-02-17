{ stdenv, unzip }:
let
  version = "3.9.4";
  versionNoDots = "394";
  versionHash = "af177845";
in
stdenv.mkDerivation {
  name = "coconut-battery-${version}";
  src = builtins.fetchurl {
    url = "https://www.coconut-flavour.com/downloads/coconutBattery_${versionNoDots}_${versionHash}.zip";
    sha256 = "1d784zwd0ym1blnns4d82wfg8bjsq1lynq2d7ijndx0s1qwdzs1a";
  };
  buildInputs = [ unzip ];
  dontUnpack = true;
  buildPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -R coconutBattery.app "$out/Applications/coconutBattery.app"
  '';
  passthru = {
    inherit version;
    mac-app = {
      label = "coconutBattery";
      icon = "AppIcon";
    };
  };
}
