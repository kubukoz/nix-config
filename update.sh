#!/usr/bin/env bash
set -euo pipefail

# The nix daemon runs as root and never reads ~/.config/nix/nix.conf, so an
# access-tokens setting there is ignored and GitHub fetches go out anonymous
# (60 req/h -> HTTP 429). We're in trusted-users, so NIX_CONFIG from the client
# is honoured. Exported here so child scripts inherit it too.
# GH_TOKEN additionally covers the plain curl calls to api.github.com in the
# per-package update scripts, which NIX_CONFIG does not reach.
GH_TOKEN=$(gh auth token --hostname github.com)
export GH_TOKEN
export NIX_CONFIG="access-tokens = github.com=${GH_TOKEN}"

./update-github.sh

git add derivations/*/sources.json

nix flake update
git add flake.lock

./compare.sh commit
./switch.sh
git push
git show
