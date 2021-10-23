{ stdenv, installShellFiles }:

let
  version = "1.7.4";
  pname = "spotify-next-native";
  src = builtins.fetchurl {
    url = "https://github.com/kubukoz/spotify-next/releases/download/v${version}/spotify-next";
    sha256 = "1ivmlrp8j8xn2l6lngj5pdbl9rbkc99pbwp114x8bjrram4hqdga";
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
