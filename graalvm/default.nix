{ pkgs ? import <nixpkgs> { } }:
let
  version = "20.3.0";
  arch = "darwin-amd64";
  sources = fetchTarball {
    url =
      "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/graalvm-ce-java11-${arch}-${version}.tar.gz";
    sha256 = "22b869fbf590c461278efae5e06fdd5ba32b4d5b302da838d9f50cb71aa20d01";
  };
  # sources = ./graalvm-ce-java11-darwin-amd64-20.3.0.tar.gz;
in with pkgs;
stdenv.mkDerivation {
  name = "graalvm-${version}";
  src = sources;
  installPhase = ''
    mkdir temp-out;
    tar -xzf $src -C temp-out;
    cp -r temp-out/graalvm-ce-java11-${version}/Contents/Home $out;
  '';
}
