{ pkgs, ... }:
let
  git-changelog = pkgs.writeScriptBin "git-changelog" ''
    LAST_TAG="$(git tag --list "v*" --sort=authordate | tail -n 1)"
    git log --pretty=oneline --pretty=format:%s "$LAST_TAG"..."master" | grep -E '#'
  '';
in
{
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
      ".bsp/"
    ];

    includes = [
      {
        condition = "gitdir:~/dev/";
        contents.user = {
          name = "Jakub Kozlowski";
          email = "jakub.kozlowski@disneystreaming.com";
        };
      }
    ];

    extraConfig = {
      pull = { ff = "only"; };
      init.defaultBranch = "main";
    };
  };

  home.packages = [ pkgs.git-crypt git-changelog ];
}
