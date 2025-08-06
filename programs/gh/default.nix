{ config, machine, ... }: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
        open = "repo view --web";
      };
    };
  };

  home.file.".config/gh/hosts.yml".source = config.lib.file.mkOutOfStoreSymlink
    (machine.homedir + "/secrets/.config/gh/hosts.yml");
}
