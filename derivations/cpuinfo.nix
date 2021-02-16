{ stdenv, unzip }:

let
  version = "1.4.6";
in

stdenv.mkDerivation {
  name = "cpuinfo-${version}";
  src = builtins.fetchurl {
    url = "https://github.com/yusukeshibata/cpuinfo/raw/${version}/dist/cpuinfo.zip";
    sha256 = "0w2pccy0l9b0l36czjr38x1mplvhbn2cjjivjf0bngc3lz8rvwdv";
  };
  buildInputs = [ unzip ];
  dontUnpack = true;
  buildPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -R cpuinfo.app "$out/Applications/cpuinfo.app"
  '';

}
