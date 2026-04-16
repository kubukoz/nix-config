#!/usr/bin/env bash
set -euo pipefail

# Update GitHub binary packages in parallel
echo "Updating GitHub binary packages..."
for pkg in derivations/*/sources.json; do
  dir=$(dirname "$pkg")
  nix_expr="let pkgs = import <nixpkgs> {}; in (pkgs.callPackage ./${dir}/package.nix {}).passthru.updateScript"
  (
    script=$(nix build --impure --expr "$nix_expr" --print-out-paths --no-link 2>/dev/null)
    "$script"
  ) &
done
wait
