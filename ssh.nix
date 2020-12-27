{ lib, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      gh = {
        host = "github.com";
        hostname = "ssh.github.com";
        port = 443;
      };
      ocado-machine = lib.hm.dag.entryAfter [ "gh" ] {
        host = "kubukoz-pro-oc.local";
        hostname = "kubukoz-pro-oc.local";
        user = "j.kozlowski";
      };
    };
  };
}
