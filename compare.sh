#!/bin/bash
set -e

nix build ~/.nixpkgs#darwinConfigurations."${HOSTNAME}".system --dry-run --impure
nix build ~/.nixpkgs#darwinConfigurations."${HOSTNAME}".system --impure
nix store diff-closures /run/current-system ./result


ACTION="$1"
if [ "$ACTION" = "commit" ]; then
    # remaining args after $1
    git commit -m "$(nix store diff-closures /run/current-system ./result | grep →)" "${@:2}"
fi
