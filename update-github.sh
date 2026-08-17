#!/usr/bin/env bash
set -euo pipefail

# Update GitHub binary packages in parallel
echo "Updating GitHub binary packages..."
pids=()
names=()
for pkg in derivations/*/sources.json; do
  dir=$(dirname "$pkg")
  nix_expr="let pkgs = import <nixpkgs> {}; in (pkgs.callPackage ./${dir}/package.nix {}).passthru.updateScript"
  (
    script=$(nix build --impure --expr "$nix_expr" --print-out-paths --no-link 2>/dev/null)
    "$script"
  ) &
  pids+=($!)
  names+=("$(basename "$dir")")
done

# A bare `wait` only reports the last job's status, which let a failed update
# (e.g. a rate-limited API call) slip through and get committed.
failed=()
for i in "${!pids[@]}"; do
  wait "${pids[$i]}" || failed+=("${names[$i]}")
done

if (( ${#failed[@]} > 0 )); then
  echo "Failed to update: ${failed[*]}" >&2
  exit 1
fi
