#! /bin/sh

set -euo pipefail

NIX_OPTS="--experimental-features 'flakes nix-command' '$@'"

machine=$1

CONFIG_PATH="${HOME}/.config/dotfiles"

nix build \
  --experimental-features 'flakes nix-command' \
  --show-trace \
  --no-link "${CONFIG_PATH}/#darwinConfigurations.${machine}.system"

result=$(nix path-info "${HOME}/.config/dotfiles/#darwinConfigurations.${machine}.system")

"${result}"/sw/bin/darwin-rebuild --flake .#"${machine}" switch
