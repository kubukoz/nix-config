{ stdenv, gnutar }:
let version = "1.0.0";

in
stdenv.mkDerivation {
  name = "ssm-helpers-${version}";
  buildInputs = [ gnutar ];

  src = builtins.fetchurl {
    url =
      "https://github.com/disneystreaming/ssm-helpers/releases/download/v${version}/ssm-helpers_${version}_Darwin_x86_64.tar.gz";
    sha256 = "1ky6z5fbzm46pcia8npmmycb3vgsynfbs6l9xrb6yrfl5jp5ic3p";
  };

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    mkdir -p $out/bin
    cp ssm $out/bin'';
}
