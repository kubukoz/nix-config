{ pkgs, ... }:
let
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension;
  inherit (pkgs) vscode-utils vscode-extensions;
in configuredExtension {
  extension = vscode-extensions.scalameta.metals;
  formatterFor = [ "scala" ];
  settings = {
    "metals.serverProperties" = [
      "-Dmetals.verbose=true"
      "-Xmx4g"
      "-Xss10m"
      "-XX:+CrashOnOutOfMemoryError"
    ];
    "metals.serverVersion" = "1.6.0+5-504901db-SNAPSHOT";
    "metals.superMethodLensesEnabled" = false;
    "metals.enableSemanticHighlighting" = false;
  };
  keybindings = [
    {
      key = "cmd+i";
      command = "metals.build-import";
    }
    {
      key = "shift+alt+cmd+i";
      command = "metals.toggle-implicit-conversions-and-classes";
    }
    {
      key = "shift+cmd+i";
      command = "metals.toggle-implicit-parameters";
    }
    {
      key = "shift+alt+cmd+t";
      command = "metals.toggle-show-inferred-type";
    }
    {
      key = "ctrl+shift+cmd+up";
      command = "metals.goto-super-method";
    }
  ];
}
