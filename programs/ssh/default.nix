{ lib, ... }:
{
  imports = [ ./semisecret-ssh.nix ];
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
      };
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
    };
  };
}
