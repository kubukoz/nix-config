{ pkgs, config, machine, ... }:
{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" ];
    };


    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "7e0eee64df6c7c81a57792674646b5feaf89f263";
          sha256 = "sha256-ixUnuNtxxmiigeVjzuV5uG6rIBPY/1vdBZF2/Qv0Trs=";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "af6f8a266ea1875b9a3e86e14796cadbe1cfbf08";
          sha256 = "sha256-BjgMhILEL/qdgfno4LR64LSB8n9pC9R+gG7IQWwgyfQ=";
        };
      }
    ];

    localVariables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      JK_MACHINE_NAME = machine.shell-name;
    };

    shellAliases = {
      lsd = "exa --long --header --git --all";
      dps = "docker-compose ps";
      dcp = "docker-compose";
      nss = "nix-shell";
      nb = "nix-build";
      ngc = "nix-collect-garbage -d";
      coursier = "cs";
    };

    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    '';

    history = {
      size = 100000;
      # path = "$HOME/.zsh_history_video";
    };

    initExtra =
      let
        iterm2-shell-integration = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/gnachman/iTerm2/90626bbb104f1ca1f0ed73aff57edf7608ec5f29/Resources/shell_integration/iterm2_shell_integration.zsh";
          sha256 = "sha256:1xk6kx5kdn5wbqgx2f63vnafhkynlxnlshxrapkwkd9zf2531bqa";
        };
      in
      ''
        source ${iterm2-shell-integration}
        # rancher
        export PATH="$HOME/.rd/bin:$PATH"
      '';
  };

}
