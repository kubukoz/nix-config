#!/usr/bin/env bash
set -e

# hmm vscode managed update

nix flake update
git add flake.lock

./compare.sh commit
git show
