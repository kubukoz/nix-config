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
      home-remote = {
        host = "home.kubukoz.com";
        hostname = "home.kubukoz.com";
        user = "debian";
      };
      home = {
        host = "kubukoz-pro.local";
        hostname = "kubukoz-pro.local";
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
