#! /bin/sh

machine=$1

CONFIG_PATH="${HOME}/.config/dotfiles"

nix build --no-link "${CONFIG_PATH}/#darwinConfigurations.${machine}.system"

result=$(nix path-info "${HOME}/.config/dotfiles/#darwinConfigurations.${machine}.system")

"${result}"/sw/bin/darwin-rebuild --flake .#"${machine}" switch
