{ pkgs, ... }:
{
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
      key = "EA7E6EFDD74E5D3F";
      signByDefault = true;
      format = "openpgp";
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
      ".mcp.json"
      "**/.cellar"
      # while I test it out
      "git-town.toml"
      ".claude/"
    ];

    settings = {
      pull = {
        ff = "only";
      };
      init.defaultBranch = "main";
      rerere.enabled = true;
      log.date = "local";

      merge.tool = "conflict-boss";
      mergetool.conflict-boss = {
        # Debug build for now; point at the release binary once it's stable.
        cmd = ''/Users/kubukoz/projects/conflict-boss/target/debug/conflict-boss --batch --yes-i-know --yes-i-really-know --base "$BASE" --ours "$LOCAL" --theirs "$REMOTE" --out "$MERGED"'';
        trustExitCode = true;
      };
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
