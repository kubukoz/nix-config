(self: super:
  let unstable = import ../unstable.nix { };
  in { inherit (unstable) dhall bottom unrar; })
