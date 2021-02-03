{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Jakub Kozłowski";
    userEmail = "kubukoz@gmail.com";

    aliases = {
      dif = "diff --staged";
      rekt = "reset --hard HEAD";
    };

    ignores = [
      ".metals/"
      ".history/"
      "**/project/metals.sbt"
      ".idea/"
      ".vscode/"
      ".bloop/"
      ".scalafmt.conf"
      ".bsp/"
      "drop-fatals.diff"
    ];

    includes = [{
      condition = "gitdir:~/dev/";
      contents.user = {
        name = "Jakub Kozlowski";
        email = "jakub.kozlowski@disneystreaming.com";
      };
    }];

    extraConfig = {
      pull = { ff = "only"; };
      init.defaultBranch = "main";
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
