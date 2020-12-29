self: super:
let
  # generates an object with a single key for every overridden extension, based on the publisher + name attrs of each.
  updatedExtensions = attrsets:
    let
      extension = attrs: {
        name = "${attrs.publisher}.${attrs.name}";
        value = self.vscode-utils.extensionFromVscodeMarketplace attrs;
      };
    in builtins.listToAttrs (map extension attrsets);
in {
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions
    (updatedExtensions [
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.9.10";
        sha256 = "0v599yssvk358gxfxnyzzkyk0y5krsbp8n4rkp9wb2ncxqsqladr";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.5.0";
        sha256 = "0rhdnj8vfpcvy771l6nhh4zxyqspyh84n9p1xp45kq6msw22d7rx";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.9.0";
        sha256 = "10xih3djdbxvndlz8s98rf635asjx8hmdza49y67v624i59jdn3x";
      }
    ]);
}
