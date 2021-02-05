{ pkgs, lib, vscode-extensions, ... }: {
  programs.vscode = with (pkgs.callPackage ./lib.nix { });
    let
      marketplaceExtension = pkgs.vscode-utils.extensionFromVscodeMarketplace;
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
          "metals.superMethodLensesEnabled" = true;
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
        extension = marketplaceExtension {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.9.12";
          sha256 = "017h9hxplf2rhmlhn3vag0wypcx6gxi7p9fgllj5jzwrl2wsjl0g";
        };
        settings = let themeName = "One Dark Pro";
        in {
          "workbench.colorTheme" = themeName;
          "oneDarkPro.italic" = false;
          "editor.tokenColorCustomizations" = {
            "[${themeName}]" = let
              # These have been stolen from https://github.com/joshdick/onedark.vim
              yellow = "#e5c07b";
              blue = "#61afef";
            in {
              "functions" = yellow;
              "variables" = yellow;
              "types" = blue;
            };
          };
        };
      };
      markdown = configuredExtension {
        extension = marketplaceExtension {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.4.0";
          sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
        };
        formatterFor = [ "markdown" ];
      };
      local-history = configuredExtension {
        extension = marketplaceExtension {
          name = "local-history";
          publisher = "xyz";
          version = "1.8.1";
          sha256 = "1mfmnbdv76nvwg4xs3rgsqbxk8hw9zr1b61har9c3pbk9r4cay7v";
        };
        settings = let historyGlobPath = "**/.history";
        in {
          "files.watcherExclude" = { "${historyGlobPath}" = true; };
          "files.exclude" = { "${historyGlobPath}" = true; };
        };
      };
      gitlens = configuredExtension {
        extension = pkgs.vscode-extensions.eamodio.gitlens;
        settings = {
          "gitlens.currentLine.enabled" = false;
          "gitlens.remotes" = [{
            domain = "github.bamtech.co";
            type = "GitHub";
          }];
        };
      };
      multiclip = configuredExtension {
        extension = marketplaceExtension {
          name = "vscode-multiclip";
          publisher = "slevesque";
          version = "0.1.5";
          sha256 = "1cg8dqj7f10fj9i0g6mi3jbyk61rs6rvg9aq28575rr52yfjc9f9";
        };
        settings = { "multiclip.bufferSize" = 100; };
        keybindings = [{
          key = "shift+cmd+v shift+cmd+v";
          command = "multiclip.list";
        }];
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
        extension = marketplaceExtension rec {
          name = "vscode-tlaplus";
          publisher = "alygin";
          version = "1.5.3-alpha1";
          sha256 = "183fd7j9zncyn8lrq25wwx2pcvdimj0vphisx6d3pzj1hrdxlk21";
          vsix = builtins.fetchurl {
            name = "${publisher}-${name}-${version}.zip";
            url =
              "https://github.com/alygin/vscode-tlaplus/releases/download/v${version}/vscode-tlaplus-1.5.3.vsix";
            sha256 = "0ypg423c5rlsf3vvcdr4yln0bagpagsy0azy73pvaqzmdrc8a6i7";
          };
        };
        settings = { "tlaplus.tlc.statisticsSharing" = "share"; };
        keybindings = [{
          key = "ctrl+cmd+enter";
          command = "tlaplus.model.check.run";
          when = "editorLangId == tlaplus";
        }];
      };
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
            bbenoist.Nix
            dhall.dhall-lang
            dhall.vscode-dhall-lsp-server
            graphql.vscode-graphql
            brettm12345.nixfmt-vscode
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "errorlens";
              publisher = "usernamehw";
              version = "3.2.4";
              sha256 = "0caxmf6v0s5kgp6cp3j1kk7slhspjv5kzhn4sq3miyl5jkrn95kx";
            }
            {
              name = "gitignore";
              publisher = "codezombiech";
              version = "0.6.0";
              sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
            }
            {
              name = "goto-next-previous-member";
              publisher = "mishkinf";
              version = "0.0.5";
              sha256 = "0kgzap1k924i95al0a63hxcsv8skhaapgfpi9d7vvaxm0fc10l1i";
            }
            {
              name = "vscode-remote-extensionpack";
              publisher = "ms-vscode-remote";
              version = "0.20.0";
              sha256 = "04wrbfsb8p258pnmqifhc9immsbv9xb6j3fxw9hzvw6iqx2v3dbi";
            }
            {
              name = "scaladex-search";
              publisher = "baccata";
              version = "0.0.1";
              sha256 = "1y8p4rr8qq5ng52g4pbx8ayq04gi2869wrx68k69rl7ga7bzcyp9";
            }
            {
              name = "vscode-spotify";
              publisher = "shyykoserhiy";
              version = "3.2.1";
              sha256 = "14d68rcnjx4a20r0ps9g2aycv5myyhks5lpfz0syr2rxr4kd1vh6";
            }
            {
              name = "shellcheck";
              publisher = "timonwong";
              version = "0.12.3";
              sha256 = "1i9rszgnac2z1kyahmgxmz05ib7z14s458fvvjlzmvl64fa1fdvf";
            }
            {
              name = "vscode-pull-request-github";
              publisher = "github";
              version = "0.22.0";
              sha256 = "13p3z86vkra26npp5a78pxdwa4z6jqjzsd38arhgdnjgwmi6bnrw";
            }
          ];
      };
    in mergeAll [
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
    ];

}
