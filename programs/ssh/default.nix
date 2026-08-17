{ ... }:
{
  imports = [ ./semisecret-ssh.nix ];
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        Compression = false;
      };
      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
      };
      "kubukoz-pro.local" = {
        HostName = "kubukoz-pro.local";
        User = "kubukoz";
      };
      "kubukoz-max.local" = {
        HostName = "kubukoz-max.local";
        User = "kubukoz";
      };
    };
  };
}
