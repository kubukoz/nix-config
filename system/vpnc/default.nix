{ pkgs, config, ... }:

{
  environment.etc = {
    # todo finally manage firefox with nix
    "vpnc/post-connect.d/setup".text = ''
      #!${pkgs.bash}
      networksetup -setdnsservers Wi-Fi ${config.semisecret.vpn-dns-server}
      sudo --user=kubukoz /Applications/Firefox.app/Contents/MacOS/firefox ${config.semisecret.vpn-home-page}
    '';
    "vpnc/post-disconnect.d/reset".text = ''
      #!${pkgs.bash}
      networksetup -setdnsservers Wi-Fi Empty
    '';
  };
}
