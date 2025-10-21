#!/usr/bin/env bash
set -euo pipefail

nix flake update
git add flake.lock

./compare.sh commit
sudo darwin-rebuild switch --flake ~/.nixpkgs --impure
git push
git show
