#!/usr/bin/env bash

set -euo pipefail

nix flake update nix-work
./switch.sh
git add --all
git commit --message 'bump work'
git push
