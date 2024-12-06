{ pkgs, ... }: {
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
    ];

    extraConfig = {
      pull = { ff = "only"; };
      init.defaultBranch = "main";
      rerere.enabled = true;
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
