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

    interactiveShellInit = let
      fzf-tab = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "cb8a784343a422ba6d8bdf60acaf4714a6a6d5f7";
        sha256 = "0255whjb3k526q1276z21w6lvalx0b2q6jsd571l69ks1bx7mr9g";
      } + "/fzf-tab.plugin.zsh";
    in ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      source $ZSH/oh-my-zsh.sh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${fzf-tab}

      # todo: fetch automatically: curl -L https://iterm2.com/shell_integration/zsh
      test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    '';
  };

}
