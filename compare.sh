#!/bin/bash
set -e

nix build ~/.nixpkgs#darwinConfigurations."${HOSTNAME}".system --dry-run
nix build ~/.nixpkgs#darwinConfigurations."${HOSTNAME}".system
nix store diff-closures /run/current-system ./result


ACTION="$1"
if [ "$ACTION" = "commit" ]; then
    # remaining args after $1
    git commit -m "$(nix store diff-closures /run/current-system ./result | grep →)" "${@:2}"
fi
