{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Jakub Kozłowski";
    userEmail = "kubukoz@gmail.com";

    delta.enable = true;

    aliases = {
      dif = "diff --staged";
      rekt = "reset --hard HEAD";
    };

    signing = {
      key = "A1DC9B6A8B59D4D6";
      signByDefault = true;
    };

    ignores = [
      "**/.metals/"
      "**/project/metals.sbt"
      "**/.idea/"
      "**/.vscode/settings.json"
      "**/.bloop/"
      "**/.bsp/"
      "**/.scala-build/"
      "**/.direnv/"
      "**/.DS_Store"
    ];

    extraConfig = {
      pull = { ff = "only"; };
      init.defaultBranch = "main";
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
