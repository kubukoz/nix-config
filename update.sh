#!/usr/bin/env bash
set -euo pipefail

# hmm vscode managed update

nix flake update
git add flake.lock

./compare.sh commit
git show
