{ pkgs, lib, ... }: with (pkgs.callPackage ./lib.nix {});

let
  marketplaceExtension = pkgs.vscode-utils.extensionFromVscodeMarketplace;

  baseSettings = {
    enable = true;
    userSettings = {
      "editor.fontFamily" =
        "'JetBrains Mono', 'Meslo LGS NF', Monaco, 'Courier New', monospace";
      "breadcrumbs.enabled" = true;
      "debug.allowBreakpointsEverywhere" = true;
      "editor.cursorBlinking" = "solid";
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "editor.renderIndentGuides" = false;
      "editor.suggestSelection" = "first";
      "editor.tabSize" = 2;
      "files.autoSave" = "onFocusChange";
      "files.defaultLanguage" = "markdown";
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;
      "typescript.preferences.quoteStyle" = "single";
      "window.zoomLevel" = 0;
      "workbench.editor.enablePreview" = false;
      "workbench.editor.limit.value" = 5;
      "workbench.editor.showTabs" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.startupEditor" = "none";
    };

    keybindings = [
      {
        key = "cmd+k cmd+n";
        command = "explorer.newFile";
      }
      {
        key = "cmd+k cmd+b";
        command = "explorer.newFolder";
      }
      {
        key = "alt+cmd+z";
        command = "git.revertSelectedRanges";
      }
    ] ++ overrideKeyBinding "f2" {
      key = "cmd+r cmd+r";
      command = "editor.action.rename";
      when =
        "editorHasRenameProvider && editorTextFocus && !editorReadonly";
    } ++ overrideKeyBinding "shift-alt+f5" {
      key = "ctrl+shift+alt+up";
      command = "workbench.action.editor.previousChange";
      when = "editorTextFocus";
    } ++ overrideKeyBinding "alt+f5" {
      key = "ctrl+shift+alt+down";
      command = "workbench.action.editor.nextChange";
      when = "editorTextFocus";
    };

    extensions = with pkgs.vscode-extensions;
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
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
    extension = pkgs.vscode-extensions.scala-lang.scala;
    settings = {
      "files.watcherExclude" = {
        "**/.bloop" = true;
        "**/.ammonite" = true;
      };
    };
  };

  prettier = configuredExtension {
    extension = pkgs.vscode-extensions.esbenp.prettier-vscode;
    formatterFor = [ "typescript" "typescriptreact" "json" "jsonc" ];
  };

  metals = configuredExtension {
    extension = pkgs.vscode-extensions.scalameta.metals;
    formatterFor = [ "scala" ];
    settings = {
      "metals.serverVersion" = "0.9.10+104-1ee67d24-SNAPSHOT";
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
    extension = pkgs.vscode-extensions.zhuangtongfa.material-theme;
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
    extension = pkgs.vscode-extensions.yzhang.markdown-all-in-one;
    formatterFor = [ "markdown" ];
  };

  local-history = configuredExtension {
    extension = pkgs.vscode-extensions.xyz.local-history;
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
    extension = pkgs.vscode-extensions.eamodio.gitlens;
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
    extension = pkgs.vscode-extensions.slevesque.vscode-multiclip;
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
    extension = pkgs.vscode-extensions.alygin.vscode-tlaplus;
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
    extension = pkgs.vscode-extensions.edonet.vscode-command-runner;
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
    extension = pkgs.vscode-extensions.jnoortheen.nix-ide;
    settings = { "nix.enableLanguageServer" = true; };
  };
in
{
  programs.vscode =
    mergeAll [
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
