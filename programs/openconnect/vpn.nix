{ writeScriptBin, bash, gawk, config }:
let
  passwordCommand = "${bash}/bin/bash ${builtins.toString ./secret-vpn.sh}";
  vpnDance = ''
    echo "VPN Dance!"
    COOKIE_FILE_NAME=$(mktemp)
    VPN_HOST="${config.semisecret.vpn-host}" \
      VPN_PORTAL_ID="${config.semisecret.vpn-portal-id}" \
      COOKIE_FILE_NAME="$COOKIE_FILE_NAME" \
      awk="${gawk}/bin/awk" \
      ${bash}/bin/bash ${./vpn-dance.sh}
    rm "$COOKIE_FILE_NAME"'';

in writeScriptBin "vpn" ''
  ${passwordCommand} | \
    sudo openconnect vpn.disneystreaming.com \
      --user jkoslowski \
      --background
  ${vpnDance}''
