{ lib, ... }: {
  imports = [ ./semisecret-ssh.nix ];
  programs.ssh = {
    enable = true;
    matchBlocks = {
      gh = {
        host = "github.com";
        hostname = "ssh.github.com";
        port = 443;
      };
      home = {
        host = "kubukoz-pro.local";
        hostname = "kubukoz-pro.local";
        user = "kubukoz";
      };
      max = {
        host = "kubukoz-max.local";
        hostname = "kubukoz-max.local";
        user = "kubukoz";
      };
      work = {
        host = "kubukoz-work.local";
        hostname = "kubukoz-work.local";
        user = "jkoslowski";
      };
    };
  };
}
