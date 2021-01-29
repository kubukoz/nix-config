(self: super:
  let unstable = import (import ../unstable.nix { pkgs = super; }) { };
  in { inherit (unstable) dhall; })
