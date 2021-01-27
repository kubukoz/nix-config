{ lib, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      gh = {
        host = "github.com";
        hostname = "ssh.github.com";
        port = 443;
      };
      home = {
        host = "home.kubukoz.com";
        hostname = "home.kubukoz.com";
        user = "debian";
      };
    };
  };
}
