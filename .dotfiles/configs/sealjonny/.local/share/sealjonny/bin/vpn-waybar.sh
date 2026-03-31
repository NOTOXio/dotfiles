#!/usr/bin/env bash

if nmcli -g TYPE connection show --active | grep -x "wireguard" &> /dev/null; then
  "$HOME/.local/share/sealjonny/bin/vpn" disconnect
else
  exec "$TERMINAL" --class=CustomVPN -e env VPN_FZF_HEIGHT=100% "$HOME/.local/share/sealjonny/bin/vpn" connect
fi
