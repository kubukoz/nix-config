#!/usr/bin/env bash
set -euo pipefail

# hmm vscode managed update

nix flake update
git add flake.lock

./compare.sh commit
darwin-rebuild switch --flake ~/.nixpkgs --impure
git push
git show
