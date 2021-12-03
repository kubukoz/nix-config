{ stdenv, installShellFiles }:

let
  version = "1.7.8";
  pname = "spotify-next-native";
  src = builtins.fetchurl {
    url = "https://github.com/kubukoz/spotify-next/releases/download/v${version}/spotify-next-macos-10.15";
    sha256 = "0ph9wr28gk65zzlyxg4sw2ml562iiab09w8dwcwy7cfr17q0lavz";
  };
  completions = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/kubukoz/spotify-next/v${version}/completions.zsh";
    sha256 = "0ip60xbq8byik7hjq7lv4w5fk8aawwdw43gxjmwy51n52qdsa23a";
  };
in
stdenv.mkDerivation {
  inherit version pname src;
  buildInputs = [ installShellFiles ];
  buildPhase = "";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/spotify-next
    chmod 0755 $out/bin/spotify-next
    installShellCompletion --name _${pname} --zsh ${completions}
  '';
}
