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
    ];

    extraConfig = { pull = { ff = "only"; }; };
  };

  home.packages = [ pkgs.git-crypt ];
}
