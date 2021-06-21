{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-utils vscode-extensions;
  pkgsUnstable = import ../unstable.nix {};
  marketplaceExtension = vscode-utils.extensionFromVscodeMarketplace;
  vscode-lib = import ./lib.nix;
  inherit (vscode-lib) configuredExtension mkVscodeModule exclude;

  baseSettings = mkVscodeModule {
    enable = true;
    package = pkgs.hello // { pname = pkgs.vscode.pname; };
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
        redhat.vscode-yaml
        dbaeumer.vscode-eslint
        usernamehw.errorlens
      ]
    ) ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-remote-extensionpack";
        publisher = "ms-vscode-remote";
        version = "0.20.0";
        sha256 = "04wrbfsb8p258pnmqifhc9immsbv9xb6j3fxw9hzvw6iqx2v3dbi";
      }
      {
        name = "nickel-syntax";
        publisher = "kubukoz";
        version = "0.0.1";
        sha256 = "010zn58j9kdb2jpxmlfyyyais51pwn7v2c5cfi4051ayd02b9n3s";
      }
      {
        name = "graph-buddy";
        publisher = "virtuslab";
        version = "0.4.21";
        sha256 = "0a7rl21r0pw6fh7ykh4y7cxxvbxah281i3nygf4g0zhzl3a7y263";
      }
    ];
  };

  rust-analyzer = configuredExtension {
    extension = vscode-utils.extensionFromVscodeMarketplace {
      name = "rust-analyzer";
      publisher = "matklad";
      version = "0.2.629";
      sha256 = "1i0mn6dlflf1wrdnxw8gw91np6afmb05qq7v3cigk2cn0hh1pgsl";
    };
    settings = { "rust-analyzer.serverPath" = "${pkgsUnstable.rust-analyzer}/bin/rust-analyzer"; };
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
        in
          {
            "workbench.colorTheme" = themeName;
            "oneDarkPro.italic" = false;
            "editor.tokenColorCustomizations"."[${themeName}]" =
              {
                functions = yellow;
                variables = yellow;
                types = blue;
              };

            "editor.semanticTokenColorCustomizations"."[${themeName}]"."rules" = {
              "variable:rust" = {
                "foreground" = yellow;
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

  liveshare = configuredExtension
    {
      extension = marketplaceExtension {
        name = "vsliveshare";
        publisher = "ms-vsliveshare";
        version = "1.0.3577";
        sha256 = "1aprpx2mhkdg26x35hxlnlr0hx28znha1y6wrrd4cw549scssp9a";
      };
      settings = { "liveshare.featureSet" = "insiders"; };
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
    liveshare
    tla
    command-runner
    nix-ide
    rust-analyzer
  ];
}
