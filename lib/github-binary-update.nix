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
  latest_version=$(curl -s "https://api.github.com/repos/${owner}/${repo}/releases?per_page=1" | jq ".[0].tag_name" --raw-output | sed 's/^v//')

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
    curl -sL -o "$asset_file" "$release_asset_url"
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
