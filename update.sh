#!/usr/bin/env bash
set -euo pipefail

nix flake update
git add flake.lock

./compare.sh commit
./switch.sh
git push
git show
