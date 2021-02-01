{ symlinkJoin, writeScriptBin, bash }:
# TODO: Add /etc/vpnc hooks with nix-darwin
# Also todo: start this as a systemctl service?
let passwordCommand = "${bash}/bin/bash ${builtins.toString ./secret-vpn.sh}";
in writeScriptBin "vpn" ''
  ${passwordCommand} | \
    sudo openconnect vpn.disneystreaming.com \
      --background \
      --user jkoslowski''
