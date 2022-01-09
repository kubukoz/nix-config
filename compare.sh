#!/bin/bash
set -e

ACTION="$1"

echo "Running compare.sh, will run $ACTION"

nix build ~/.nixpkgs#darwinConfigurations.${HOSTNAME}.system
nix store diff-closures /run/current-system ./result

if [ "$ACTION" = "commit" ]; then
    git commit -m "$(nix store diff-closures /run/current-system ./result | grep →)"
fi
