{ pkgs, ... }: {
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;

  programs.git = {
    enable = true;
    settings.user.name = "Jakub Kozłowski";
    settings.user.email = "kubukoz@gmail.com";

    settings.alias = {
      dif = "diff --staged";
      rekt = "reset --hard HEAD";
    };

    signing = {
      key = "A061936F31D567DC";
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
      "**/smithyql-log.txt"
      "**/.claude/settings.local.json"
    ];

    settings = {
      pull = { ff = "only"; };
      init.defaultBranch = "main";
      rerere.enabled = true;
      log.date = "local";
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
