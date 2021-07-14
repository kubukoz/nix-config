{ pkgs, ... }:
let
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension managedPackages;
  inherit (pkgs) vscode-utils vscode-extensions;

  managed = managedPackages {
    file = ./extensions/managed.nix;
    inherit (pkgs) vscode-utils;
  };

in
configuredExtension {
  extension = managed.scalameta.metals;
  formatterFor = [ "scala" ];
  settings = {
    # "metals.serverVersion" = "0.10.4+155-56fbd612-SNAPSHOT";
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
