#!/usr/bin/env bash
set -euo pipefail

./update-github.sh

git add derivations/*/sources.json

nix flake update
git add flake.lock

./compare.sh commit
./switch.sh
git push
git show
