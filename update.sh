#!/usr/bin/env bash
set -e

# hmm vscode managed update

nix flake update

./compare.sh commit
