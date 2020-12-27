{ pkgs ? import <nixpkgs> { }, path, name }:

pkgs.stdenv.mkDerivation {
  name = "untar-${name}";
  src = path;
  buildInputs = [ pkgs.gnutar ];
  installPhase = ''
    mkdir $out;
    tar -xzf $src -C $out;
  '';
}
