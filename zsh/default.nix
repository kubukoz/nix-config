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

    shellInit = let
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "zsh-interactive-cd" # installed manually in ~/.oh-my-zsh/custom/plugins
      ];
    in ''
      plugins=(${builtins.concatStringsSep " " plugins})
    '';

    variables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
      ZSH_CUSTOM = "$HOME/.oh-my-zsh/custom";
    };

    interactiveShellInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      source $ZSH/oh-my-zsh.sh

      # todo: fetch automatically: curl -L https://iterm2.com/shell_integration/zsh
      test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    '';
  };

}
