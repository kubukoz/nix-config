{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-extensions;
  inherit (pkgs.callPackage ../lib { }) attributesFromListFile;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension mkVscodeModule exclude;

  auto-extensions = attributesFromListFile {
    file = ./extensions/auto.nix;
    root = vscode-extensions;
  };

  baseSettings = mkVscodeModule {
    enable = true;
    package = pkgs.runCommand "dummy" { } "mkdir $out" // { pname = pkgs.vscode.pname; };
    userSettings = import ./global-settings.nix;
    keybindings = import ./global-keybindings.nix { inherit vscode-lib; };

    extensions = auto-extensions;
  };

  indent-rainbow = configuredExtension {
    extension = vscode-extensions.oderwat.indent-rainbow;
    settings = {
      "indentRainbow.includedLanguages" = [ "yaml" "dockercompose" ];
    };
  };
  scala = configuredExtension
    {
      extension = vscode-extensions.scala-lang.scala;
      settings = exclude [ "**/.bloop" "**/.ammonite" "**/.metals" "**/.scala-build" ];
    };

  prettier = configuredExtension
    {
      extension = vscode-extensions.esbenp.prettier-vscode;
      formatterFor = [ "typescript" "typescriptreact" "javascript" "javascriptreact" "json" "jsonc" "html" ];
    };

  markdown = configuredExtension
    {
      extension = vscode-extensions.yzhang.markdown-all-in-one;
      formatterFor = [ "markdown" ];
    };


  gitlens = configuredExtension
    {
      extension = vscode-extensions.eamodio.gitlens;
      settings = {
        "gitlens.currentLine.enabled" = false;
      };
    };

  multiclip = configuredExtension
    {
      extension = vscode-extensions.slevesque.vscode-multiclip;
      settings = { "multiclip.bufferSize" = 100; };
      keybindings = [
        {
          key = "shift+cmd+v shift+cmd+v";
          command = "multiclip.list";
        }
      ];
    };

  tla = configuredExtension
    {
      extension = vscode-extensions.alygin.vscode-tlaplus;
      settings = { "tlaplus.tlc.statisticsSharing" = "share"; };
      keybindings = [
        {
          key = "ctrl+cmd+enter";
          command = "tlaplus.model.check.run";
          when = "editorLangId == tlaplus";
        }
      ];
    };

  command-runner = configuredExtension
    {
      extension = vscode-extensions.edonet.vscode-command-runner;
      keybindings = [
        {
          key = "ctrl+cmd+enter";
          command = "command-runner.run";
          args = { command = "darwin-rebuild switch --flake ~/.nixpkgs --impure"; };
          when = "editorLangId == nix";
        }
      ];
    };

  nix-ide = configuredExtension
    {
      extension = vscode-extensions.jnoortheen.nix-ide;
      settings = {
        "nix.enableLanguageServer" = true;
        "files.associations" = { "flake.lock" = "json"; };
      } // exclude [ ".direnv/" ];
    };

  langoustine = configuredExtension {
    extension = vscode-extensions.neandertech.langoustine-vscode;
    settings = {
      "langoustine-vscode.servers" = [
        {
          "name" = "grammar-js-lsp";
          "command" = pkgs.fetchurl {
            url = "https://github.com/keynmol/grammar-js-lsp/releases/download/v0.0.3/grammar-js-lsp-macos";
            sha256 = "sha256-V9e5Zl0jj6PzrlMiNnN/igtDW2OjJZu9p6466LKSiTo=";
            executable = true;
          };
          "extension" = "grammar.js";
        }
      ];
    };
  };
in
{
  imports = [
    baseSettings
    ./theme.nix
    scala
    ./metals.nix
    prettier
    markdown
    gitlens
    multiclip
    tla
    command-runner
    nix-ide
    indent-rainbow
    langoustine
  ];
}
