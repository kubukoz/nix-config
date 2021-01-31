{
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
    aliases = {
      co = "pr checkout";
      open = "repo view --web";
    };
  };
}
