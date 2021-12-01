{ nixpkgs }: final: prev:
let pkgs_x86 = import nixpkgs { localSystem = "x86_64-darwin"; }; in

if prev.stdenv.isAarch64 then {
  inherit (pkgs_x86) bloop scala-cli niv;
} else { }
