{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-powerlevel10k
    zsh-autosuggestions
  ];

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    enableFzfGit = true; # todo: verify it even works

    shellInit = let plugins = [ "git" "docker" "docker-compose" ];
    in ''
      plugins=(${builtins.concatStringsSep " " plugins})
    '';

    variables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
    };

    interactiveShellInit =
      # todo: replace with fzf-tab
      # git@github.com:changyuheng/zsh-interactive-cd.git
      let
        zsh-interactive-cd = pkgs.fetchFromGitHub {
          owner = "changyuheng";
          repo = "zsh-interactive-cd";
          rev = "1cfccb9a2c9928c7bbab3129ad1923390b28a612";
          sha256 = "0spw10aw0a27hlrdb189lcfkijn83rmzpizxblcjm9vmxpm8vaj4";
        } + "/zsh-interactive-cd.plugin.zsh";
      in ''
        # powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        source $ZSH/oh-my-zsh.sh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${zsh-interactive-cd}

        # todo: fetch automatically: curl -L https://iterm2.com/shell_integration/zsh
        test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
      '';
  };

}
