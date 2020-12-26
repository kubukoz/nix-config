{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;

    shellInit = let
      plugins = [
        "git"
        "zsh-autosuggestions"
        "docker"
        "docker-compose"
        "zsh-interactive-cd"
      ];
    in ''
      plugins=(${builtins.concatStringsSep " " plugins})
    '';

    variables = {
      ZSH_THEME = "powerlevel10k/powerlevel10k";
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      ZSH = "$HOME/.oh-my-zsh";
    };

    interactiveShellInit = ''
      source $ZSH/oh-my-zsh.sh
      test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

}
