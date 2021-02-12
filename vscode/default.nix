{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-utils vscode-extensions;
  marketplaceExtension = vscode-utils.extensionFromVscodeMarketplace;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension mkVscodeModule;

  baseSettings = mkVscodeModule {
    enable = true;
    userSettings = import ./global-settings.nix;
    keybindings = import ./global-keybindings.nix { inherit vscode-lib; };

    extensions = (
      with vscode-extensions;
      [
        ms-azuretools.vscode-docker
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        graphql.vscode-graphql
        codezombiech.gitignore
        mishkinf.goto-next-previous-member
        baccata.scaladex-search
        shyykoserhiy.vscode-spotify
        timonwong.shellcheck
        github.vscode-pull-request-github
      ]
    ) ++ vscode-utils.extensionsFromVscodeMarketplace [
      # no license for this one lol
      {
        name = "errorlens";
        publisher = "usernamehw";
        version = "3.2.4";
        sha256 = "0caxmf6v0s5kgp6cp3j1kk7slhspjv5kzhn4sq3miyl5jkrn95kx";
      }
      {
        name = "vscode-remote-extensionpack";
        publisher = "ms-vscode-remote";
        version = "0.20.0";
        sha256 = "04wrbfsb8p258pnmqifhc9immsbv9xb6j3fxw9hzvw6iqx2v3dbi";
      }
    ];
  };

  scala = configuredExtension {
    extension = vscode-extensions.scala-lang.scala;
    settings = {
      "files.watcherExclude" = {
        "**/.bloop" = true;
        "**/.ammonite" = true;
      };
    };
  };

  prettier = configuredExtension {
    extension = vscode-extensions.esbenp.prettier-vscode;
    formatterFor = [ "typescript" "typescriptreact" "json" "jsonc" ];
  };

  metals = configuredExtension {
    extension = vscode-extensions.scalameta.metals;
    formatterFor = [ "scala" ];
    settings = {
      "metals.serverVersion" = "0.9.10+113-519c6414-SNAPSHOT";
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
  };

  oneDarkPro = configuredExtension {
    extension = vscode-extensions.zhuangtongfa.material-theme;
    settings =
      let
        themeName = "One Dark Pro";
      in
        {
          "workbench.colorTheme" = themeName;
          "oneDarkPro.italic" = false;
          "editor.tokenColorCustomizations" = {
            "[${themeName}]" =
              let
                # These have been stolen from https://github.com/joshdick/onedark.vim
                yellow = "#e5c07b";
                blue = "#61afef";
              in
                {
                  "functions" = yellow;
                  "variables" = yellow;
                  "types" = blue;
                };
          };
        };
  };

  markdown = configuredExtension {
    extension = vscode-extensions.yzhang.markdown-all-in-one;
    formatterFor = [ "markdown" ];
  };

  local-history = configuredExtension {
    extension = vscode-extensions.xyz.local-history;
    settings =
      let
        historyGlobPath = "**/.history";
      in
        {
          "files.watcherExclude" = { "${historyGlobPath}" = true; };
          "files.exclude" = { "${historyGlobPath}" = true; };
        };
  };

  gitlens = configuredExtension {
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

  multiclip = configuredExtension {
    extension = vscode-extensions.slevesque.vscode-multiclip;
    settings = { "multiclip.bufferSize" = 100; };
    keybindings = [
      {
        key = "shift+cmd+v shift+cmd+v";
        command = "multiclip.list";
      }
    ];
  };

  liveshare = configuredExtension {
    extension = marketplaceExtension {
      name = "vsliveshare";
      publisher = "ms-vsliveshare";
      version = "1.0.3577";
      sha256 = "1aprpx2mhkdg26x35hxlnlr0hx28znha1y6wrrd4cw549scssp9a";
    };
    settings = { "liveshare.featureSet" = "insiders"; };
  };

  tla = configuredExtension {
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

  command-runner = configuredExtension {
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

  nix-ide = configuredExtension {
    extension = vscode-extensions.jnoortheen.nix-ide;
    settings = { "nix.enableLanguageServer" = true; };
  };
in
{
  imports = [
    baseSettings
    scala
    metals
    oneDarkPro
    prettier
    markdown
    local-history
    gitlens
    multiclip
    liveshare
    tla
    command-runner
    nix-ide
  ];
}
