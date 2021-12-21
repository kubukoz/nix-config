#!/bin/bash
set -e

darwin-rebuild build --flake ~/.nixpkgs
nix store diff-closures /run/current-system ./result

echo "===================="
echo "notable changes"
echo "===================="
echo ""

nix store diff-closures /run/current-system ./result | grep →
