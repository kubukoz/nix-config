{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-extensions;
  inherit (pkgs.callPackage ../lib {}) attributesFromListFile;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension mkVscodeModule exclude managedPackages;

  auto-extensions = attributesFromListFile {
    file = ./extensions/auto.nix;
    root = vscode-extensions;
  };

  managed = managedPackages {
    file = ./extensions/managed.nix;
    inherit (pkgs) vscode-utils;
  };

  baseSettings = mkVscodeModule {
    enable = true;
    package = pkgs.hello // { pname = pkgs.vscode.pname; };
    userSettings = import ./global-settings.nix;
    keybindings = import ./global-keybindings.nix { inherit vscode-lib; };

    extensions = auto-extensions ++ [
      managed.ms-vscode-remote.vscode-remote-extensionpack
      managed.kubukoz.nickel-syntax
      managed.virtuslab.graph-buddy
      managed.arrterian.nix-env-selector
      managed.octref.vetur
    ];
  };

  indent-rainbow = configuredExtension {
    extension = managed.oderwat.indent-rainbow;
    settings = {
      "indentRainbow.includedLanguages" = [ "yaml" ];
    };
  };
  rust-analyzer = configuredExtension {
    extension = pkgs.vscode-extensions.matklad.rust-analyzer;
    settings = { "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer"; };
  };
  scala = configuredExtension
    {
      extension = vscode-extensions.scala-lang.scala;
      settings = exclude [ "**/.bloop" "**/.ammonite" ".metals" ];
    };

  prettier = configuredExtension
    {
      extension = vscode-extensions.esbenp.prettier-vscode;
      formatterFor = [ "typescript" "typescriptreact" "javascript" "javascriptreact" "json" "jsonc" ];
    };

  oneDarkPro = configuredExtension
    {
      extension = vscode-extensions.zhuangtongfa.material-theme;
      settings =
        let
          themeName = "One Dark Pro";
          # These have been stolen from https://github.com/joshdick/onedark.vim
          yellow = "#e5c07b";
          blue = "#61afef";
          light-grey = "#abb2bf";
        in
          {
            "workbench.colorTheme" = themeName;
            "oneDarkPro.italic" = false;
            "editor.tokenColorCustomizations"."[${themeName}]" =
              {
                functions = yellow;
                variables = yellow;
                types = blue;
                "textMateRules" = [
                  {
                    "scope" = [ "support.function" "source.smithy" ];
                    "settings" = {
                      "foreground" = light-grey;
                    };
                  }
                ];
              };


            "editor.semanticTokenColorCustomizations"."[${themeName}]"."rules" = {
              "variable:rust" = {
                "foreground" = yellow;
              };
              "function:smithy" = {
                "foreground" = blue;
              };
            };
          };
    };

  markdown = configuredExtension
    {
      extension = vscode-extensions.yzhang.markdown-all-in-one;
      formatterFor = [ "markdown" ];
    };

  local-history = configuredExtension
    {
      extension = vscode-extensions.xyz.local-history;
      settings =
        let
          historyGlobPath = "**/.history";
        in
          exclude [ historyGlobPath ];
    };

  gitlens = configuredExtension
    {
      extension = vscode-extensions.eamodio.gitlens;
      settings = {
        "gitlens.currentLine.enabled" = false;
        "gitlens.remotes" = [
          {
            domain = "github.bamtech.co";
            type = "GitHub";
          }
        ];
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
          args = { command = "darwin-rebuild switch"; };
          when = "editorLangId == nix";
        }
      ];
    };

  nix-ide = configuredExtension
    {
      extension = vscode-extensions.jnoortheen.nix-ide;
      settings = { "nix.enableLanguageServer" = true; };
    };
in
{
  imports = [
    baseSettings
    scala
    ./metals.nix
    oneDarkPro
    prettier
    markdown
    local-history
    gitlens
    multiclip
    tla
    command-runner
    nix-ide
    rust-analyzer
    indent-rainbow
  ];
}
