#!/usr/bin/env bash

# Adapted from https://github.com/tadfisher/flake/blob/44c998ef12060876f07b9203360acad23744931e/pkgs/plex-plexpass/update.sh

shopt -s extglob
set -eu -o pipefail

path="$(realpath "$(dirname "$0")")"

declare -A platforms=(
    [linux-x86_64]=x86_64-linux
    [linux-aarch64]=aarch64-linux
)

token=$(cat "/secrets/plex/token")
# manifest=$(curl -s "https://plex.tv/api/downloads/5.json?channel=plexpass" -H "X-Plex-Token: ${token}")
manifest=$(curl -s "https://plex.tv/api/downloads/5.json" -H "X-Plex-Token: ${token}")
version=$(echo "$manifest" | jq -r '.computer.Linux.version | split("-") | .[0]')

tmp="$path/sources.tmp.json"
echo '' > $tmp

for arch in "${!platforms[@]}"; do
  url="$(echo "$manifest" | jq --arg arch "$arch" -r '.computer.Linux.releases[] | select(.distro == "debian" and .build == $arch) .url')"
  hash="$(nix-prefetch-url "$url")"
  nixPlatform=${platforms[$arch]}
  jq --arg version $version \
     --arg platform $nixPlatform \
     --arg url "$url" \
     --arg hash $hash \
     -n '$ARGS.named' >> $tmp
done

jq -s '.' $tmp > "$path/sources.json"
rm $tmp
