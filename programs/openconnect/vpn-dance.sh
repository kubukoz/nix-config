#!/bin/env bash
vpn_base="https://$VPN_HOST:8443/portal"
vpn_home_page="$vpn_base/PortalSetup.action?portal=$VPN_PORTAL_ID"
vpn_login_page="$vpn_base/ClientProvisionStart.action?from=CLIENT_PROVISION"
vpn_post="$vpn_base/DoCoA.action"

echo "Waiting for host to be available"

while true; sleep 0.2; do ping -c1 "$VPN_HOST" > /dev/null && break; done

echo "Connection to host established"
echo "Using ${COOKIE_FILE_NAME} as cookie jar"

# Get the cookies from here
curl -L "$vpn_home_page" --cookie-jar "$COOKIE_FILE_NAME" --silent > /dev/null

# # Make this GET for some obscure reason
curl -L "$vpn_login_page" --cookie "$COOKIE_FILE_NAME" --silent > /dev/null

# # Extract our precious cookies for sending as form data
SESSION_ID=$(grep portalSessionId < "$COOKIE_FILE_NAME" | $awk '{print $7}')
TOKEN=$(grep token < "$COOKIE_FILE_NAME" | $awk '{print $7}')

# Post our cookies
curl -L "$vpn_post" \
  --data delayToCoA="0" \
  --data coaType="Reauth" \
  --data coaSource="GUEST" \
  --data coaReason="Guest+authenticated+for+network+access" \
  --data waitForCoA="true" \
  --data portalSessionId="$SESSION_ID" \
  --data token="$TOKEN"

