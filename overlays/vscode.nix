self: super:
let
  withManaged = base:
    let
      mkExtension = ext: {
        ${ext.publisher}.${ext.name} =
          self.vscode-utils.extensionFromVscodeMarketplace ext;
      };
      exts = builtins.map mkExtension (import ../vscode/extensions/managed.nix);
    in builtins.foldl' self.lib.recursiveUpdate base exts;
in { vscode-extensions = withManaged super.vscode-extensions; }
