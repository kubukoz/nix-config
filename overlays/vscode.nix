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
    in builtins.listToAttrs (map extension attrsets);
in {
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions
    (updatedExtensions [
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.9.13";
        sha256 = "0vrg25ygmyjx1lwif2ypyv688b290ycfn1qf0izxbmgi2z3f0wf9";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.5.1";
        sha256 = "0p9nhds2xn08xz8x822q15jdrdlqkg2wa1y7mk9k89n8n2kfh91g";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.9.1";
        sha256 = "1l7pm3s5kbf2vark164ykz4qbpa1ac9ls691hham36f6v91dmff9";
      }
    ]);
}
