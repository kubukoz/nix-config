{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfHistory = true;
    # To avoid conflict with built-in completions in Nix 2.4
    enableCompletion = false;
  };
}
