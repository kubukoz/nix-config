{ pkgs, ... }:
let
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension;
  inherit (pkgs) vscode-utils vscode-extensions;
in
configuredExtension {
  extension = vscode-extensions.scalameta.metals;
  formatterFor = [ "scala" ];
  settings = {
    "metals.serverVersion" = "0.11.1+74-558d667d-SNAPSHOT";
    "metals.serverProperties" = [ "-Dmetals.verbose" "-Xmx4g" "-Xss10m" "-XX:+CrashOnOutOfMemoryError" ];
    "files.watcherExclude" = { "**/.metals" = true; };
    "metals.superMethodLensesEnabled" = false;
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
