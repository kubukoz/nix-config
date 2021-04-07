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
    "metals.serverVersion" = "0.10.1";
    "metals.serverProperties" = [ "-Dmetals.verbose" ];
    "files.watcherExclude" = { "**/.metals" = true; };
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
