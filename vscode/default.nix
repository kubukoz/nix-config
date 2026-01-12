{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-extensions vscode-utils;
  inherit (pkgs.callPackage ../lib { }) attributesFromListFile;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension mkVscodeModule exclude;

  auto-extensions = attributesFromListFile {
    file = ./extensions/auto.nix;
    root = vscode-extensions;
  };

  baseSettings = mkVscodeModule {
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
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
  scala = configuredExtension {
    extension = vscode-extensions.scala-lang.scala;
    settings = exclude [
      "**/.idea"
      "**/.bloop"
      "**/.ammonite"
      "**/.metals"
      "**/.scala-build"
      "**/target"
    ];
  };

  prettier = configuredExtension {
    extension = vscode-extensions.esbenp.prettier-vscode;
    formatterFor = [
      "typescript"
      "typescriptreact"
      "javascript"
      "javascriptreact"
      "json"
      "jsonc"
      "html"
    ];
  };

  markdown = configuredExtension {
    extension = vscode-extensions.yzhang.markdown-all-in-one;
    formatterFor = [ "markdown" ];
  };

  gitlens = configuredExtension {
    extension = vscode-extensions.eamodio.gitlens;
    settings = { "gitlens.currentLine.enabled" = false; };
  };

  multiclip = configuredExtension {
    extension = vscode-extensions.slevesque.vscode-multiclip;
    settings = { "multiclip.bufferSize" = 100; };
    keybindings = [{
      key = "shift+cmd+v shift+cmd+v";
      command = "multiclip.list";
    }];
  };

  command-runner = configuredExtension {
    extension = vscode-extensions.edonet.vscode-command-runner;
    keybindings = [{
      key = "ctrl+cmd+enter";
      command = "command-runner.run";
      args = {
        command = "sudo darwin-rebuild switch --flake ~/.nixpkgs --impure";
      };
      when = "editorLangId == nix";
    }];
  };

  nix-ide = configuredExtension {
    extension = vscode-extensions.jnoortheen.nix-ide;
    settings = {
      "nix.enableLanguageServer" = true;
      "files.associations" = { "flake.lock" = "json"; };
      "nix.serverSettings" = {
        nil.formatting.command = [ (pkgs.lib.getExe pkgs.nixfmt-classic) ];
      };
    } // exclude [ ".direnv/" ];
  };

in {
  programs.vscode = {
    enable = true;
    package = pkgs.runCommand "dummy" { } "mkdir $out" // {
      pname = pkgs.vscode.pname;
      version = "0.0.0";
    };
  };

  imports = [
    (let
      pkl = let
        name = "pkl";
        vscodeExtPublisher = "apple";
        version = "0.20.0";
      in vscode-utils.buildVscodeExtension {
        inherit name vscodeExtPublisher version;
        pname = name;
        vscodeExtName = name;
        vscodeExtUniqueId = "${vscodeExtPublisher}.${name}";
        buildInputs = [ pkgs.unzip ];
        src = builtins.fetchurl {
          name = "${name}-vscode.zip";
          url =
            "https://github.com/apple/pkl-vscode/releases/download/0.21.0/pkl-vscode-0.21.0.vsix";
          sha256 = "sha256-6URLP5G7U9V7p46bh2EoaUHx5Dp7D9Q+hjs0TGnX60k=";
        };
      };
    in configuredExtension {
      extension = pkl;
      settings = {
        "pkl.lsp.java.path" = lib.getExe pkgs.jdk25;
        "pkl.cli.path" = pkgs.pkl;
      };
    })
    baseSettings
    ./theme.nix
    scala
    ./metals.nix
    prettier
    markdown
    gitlens
    multiclip
    command-runner
    nix-ide
    indent-rainbow
  ];
}
