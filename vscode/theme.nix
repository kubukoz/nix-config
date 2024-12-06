{ pkgs, ... }:
let
  inherit (pkgs) vscode-extensions;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension;

in configuredExtension {
  extension = vscode-extensions.zhuangtongfa.material-theme;
  settings = let
    themeName = "One Dark Pro";
    # These have been stolen from https://github.com/joshdick/onedark.vim
    yellow = "#e5c07b";
    blue = "#61afef";
    light-grey = "#abb2bf";
  in {
    "workbench.colorTheme" = themeName;
    "oneDarkPro.italic" = false;
    "editor.tokenColorCustomizations"."[${themeName}]" = {
      functions = yellow;
      variables = yellow;
      types = blue;
      "textMateRules" = [{
        "scope" = [ "support.function" "source.smithy" ];
        "settings" = { "foreground" = light-grey; };
      }];
    };

    "editor.semanticTokenColorCustomizations"."[${themeName}]"."rules" = {
      "variable:rust" = { "foreground" = yellow; };
      "function:smithy" = { "foreground" = blue; };
    };
  };
}
