{ pkgs, lib, vscode-extensions, ... }: {
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
  programs.vscode = {
    enable = true;
    userSettings = let
      mergeAll = builtins.foldl' lib.recursiveUpdate { };
      theme = let themeName = "One Dark Pro";
      in {
        "workbench.colorTheme" = themeName;
        "oneDarkPro.italic" = false;
        "editor.tokenColorCustomizations" = {
          "[${themeName}]" = {
            "functions" = "#e5c07b";
            "variables" = "#e5c07b";
            "types" = "#61afef";
          };
        };
        "editor.fontFamily" =
          "'JetBrains Mono', Menlo, Monaco, 'Courier New', monospace";
      };
      scala = {
        "[scala]" = { "editor.defaultFormatter" = "scalameta.metals"; };
        "metals.serverProperties" = [ "-Dmetals.verbose" ];
        "metals.superMethodLensesEnabled" = true;
      };
      otherSettings = {
        "[json]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };
        "breadcrumbs.enabled" = true;
        "debug.allowBreakpointsEverywhere" = true;
        "editor.cursorBlinking" = "solid";
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.renderIndentGuides" = false;
        "editor.suggestSelection" = "first";
        "editor.tabSize" = 2;
        "files.autoSave" = "onFocusChange";
        "files.autoSaveDelay" = 500;
        "files.defaultLanguage" = "markdown";
        "files.exclude" = { "**/.history" = true; };
        "files.insertFinalNewline" = true;
        "files.trimTrailingWhitespace" = true;
        "files.watcherExclude" = {
          "**/.bloop" = true;
          "**/.metals" = true;
          "**/.ammonite" = true;
        };
        "gitlens.currentLine.enabled" = false;
        "liveshare.featureSet" = "insiders";
        "multiclip.bufferSize" = 100;
        "typescript.preferences.quoteStyle" = "single";
        "window.zoomLevel" = 1;
        "workbench.editor.enablePreview" = false;
        "workbench.editor.limit.value" = 5;
        "workbench.editor.showTabs" = true;
      };
    in mergeAll [ theme scala otherSettings ];
    keybindings = let
      overrideKey = originalKey: setting: [
        setting
        (setting // {
          key = originalKey;
          command = "-${setting.command}";
        })
      ];
    in [
      {
        key = "cmd+i";
        command = "metals.build-import";
      }
      {
        key = "cmd+k cmd+n";
        command = "explorer.newFile";
      }
      {
        key = "cmd+k cmd+b";
        command = "explorer.newFolder";
      }
      {
        key = "shift+cmd+v shift+cmd+v";
        command = "multiclip.list";
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
        key = "ctrl+shift+cmd+up";
        command = "metals.goto-super-method";
      }
    ] ++ overrideKey "f2" {
      key = "cmd+r cmd+r";
      command = "editor.action.rename";
      when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
    };
    extensions = [ pkgs.vscode-extensions.scalameta.metals ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ { } ];
  };
}
