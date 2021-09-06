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
    # "metals.serverVersion" = "0.10.6-M1+84-433b0161-SNAPSHOT";
    "metals.serverProperties" = [ "-Dmetals.verbose" "-Xmx4g" ];
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
