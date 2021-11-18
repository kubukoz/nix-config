_: super:
let
  sources = import ../nix/sources.nix;
in
{
  unstable = import sources.unstable { inherit (super) system; };
}
