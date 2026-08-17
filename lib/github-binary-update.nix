{
  lib,
  curl,
  writeShellScript,
  jq,
  gnused,
  git,
  nix,
  coreutils,
}:
{
  owner,
  repo,
  sourcesFile,
  platforms,
  pname,
  version,
}:

writeShellScript "${pname}-update-script" ''
  set -o errexit
  PATH=${
    lib.makeBinPath [
      curl
      jq
      gnused
      git
      nix
      coreutils
    ]
  }

  echo "${pname}: checking for updates..."

  # The API call is anonymous (60 req/h) unless we pass a token. GH_TOKEN is
  # exported by update.sh; NIX_CONFIG's access-tokens only covers nix's own
  # fetcher, not this curl.
  auth_args=()
  if [[ -n "''${GH_TOKEN:-}" ]]; then
    auth_args=(--header "Authorization: Bearer $GH_TOKEN")
  fi

  # --fail turns 403/429/404 into a non-zero exit rather than a JSON error
  # object that jq happily reduces to the string "null".
  releases=$(curl -sS --fail "''${auth_args[@]}" \
    "https://api.github.com/repos/${owner}/${repo}/releases?per_page=1")

  latest_version=$(jq ".[0].tag_name // empty" --raw-output <<< "$releases" | sed 's/^v//')

  if [[ -z "$latest_version" ]]; then
    echo "${pname}: could not determine latest version, skipping" >&2
    exit 1
  fi

  if [[ "${version}" = "$latest_version" ]]; then
      echo "${pname}: already up to date (${version})"
      exit 0
  fi

  echo "${pname}: updating ${version} -> $latest_version"

  nixpkgs=$(git rev-parse --show-toplevel)
  sources_json="$nixpkgs/${sourcesFile}"

  platform_assets=()

  for platform in ${lib.concatStringsSep " " platforms}; do
    asset=$(jq ".assets.\"$platform\".asset" --raw-output < $sources_json)
    release_asset_url="https://github.com/${owner}/${repo}/releases/download/v$latest_version/$asset"

    echo "${pname}: fetching $asset for $platform..."
    asset_file=$(mktemp /private/tmp/github-binary-update.XXXXXX)
    if ! curl -sSL --fail -o "$asset_file" "$release_asset_url"; then
      rm -f "$asset_file"
      echo "${pname}: failed to download $asset from $release_asset_url" >&2
      exit 1
    fi
    asset_hash=$(nix hash file --sri "$asset_file")
    rm "$asset_file"

    asset_object=$(jq --compact-output --null-input \
      --arg asset "$asset" \
      --arg sha256 "$asset_hash" \
      --arg platform "$platform" \
      '{asset: $asset, sha256: $sha256, platform: $platform}')
    platform_assets+=($asset_object)
  done

  printf '%s\n' "''${platform_assets[@]}" | \
    jq -s "map ( { (.platform): . | del(.platform) }) | add" | \
    jq --arg version $latest_version \
      '{ version: $version, assets: . }' > $sources_json

  echo "${pname}: updated to $latest_version"
''
