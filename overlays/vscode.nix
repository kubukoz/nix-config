self: super:
let
  # generates an object with a single key for every overridden extension, based on the publisher + name attrs of each.
  updatedExtensions = attrsets:
    let
      extension = attrs: {
        name = attrs.publisher;
        value = {
          "${attrs.name}" =
            self.vscode-utils.extensionFromVscodeMarketplace attrs;
        };
      };
    in
      builtins.listToAttrs (map extension attrsets);
in
{
  vscode-extensions =
    # no overrides for now
    self.lib.recursiveUpdate super.vscode-extensions (updatedExtensions []);

  vscode = super.vscode // {
    mac-app = {
      label = "Visual Studio Code";
      icon = "Code.icns";
    };
  };
}
