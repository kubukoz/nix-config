self: super:
let
  inherit (import ../vscode/lib.nix) managedPackages vscode-utils;
  managed = managedPackages {
    file = ../vscode/extensions/managed.nix;
    inherit (super) vscode-utils;
  };
in
{
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions {
    baccata.scaladex-search = managed.baccata.scaladex-search;
  };
}
