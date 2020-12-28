{ stdenv, gcc }:

let version = "0.1.4";
in stdenv.mkDerivation {
  name = "pidof-${version}";
  buildInputs = [ gcc ];
  src = builtins.fetchTarball {
    url = "http://www.nightproductions.net/downloads/pidof_source.tar.gz";
    sha256 = "0jrlh635y55dy84swy3fqkpnwhiw5g38536pi8j710hl2fc6pihf";
  };

  buildPhase = ''
    make pidof
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp pidof $out/bin
  '';
}
