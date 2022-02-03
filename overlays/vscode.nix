self: super:
let
  inherit (import ../vscode/lib.nix) managedPackages vscode-utils;
  managed = managedPackages {
    file = ../vscode/extensions/managed.nix;
    inherit (super) vscode-utils;
  };
in
{
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions {
    baccata.scaladex-search = managed.baccata.scaladex-search;
    edonet.vscode-command-runner = managed.edonet.vscode-command-runner;
    github.copilot = managed.github.copilot;
    codezombiech.gitignore = managed.codezombiech.gitignore;
    mishkinf.goto-next-previous-member = managed.mishkinf.goto-next-previous-member;
    graphql.vscode-graphql = managed.graphql.vscode-graphql;
    jnoortheen.nix-ide = managed.jnoortheen.nix-ide;
    zhuangtongfa.material-theme = managed.zhuangtongfa.material-theme;
    timonwong.shellcheck = managed.timonwong.shellcheck;
    alygin.vscode-tlaplus = managed.alygin.vscode-tlaplus;
  };
}
