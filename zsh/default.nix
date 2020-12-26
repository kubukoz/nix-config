{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;

    shellInit =
      let plugins = [ "git" "zsh-autosuggestions" "docker" "docker-compose" ];
      in "plugins=(${builtins.concatStringsSep " " plugins})";
    variables = {
      ZSH_THEME = "powerlevel10k/powerlevel10k";
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
    };
  };

}
