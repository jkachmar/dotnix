# Packages that are pinned with newer (or different) versions than are present
# in the nixpkgs package tree.
let
  sources = import ../nix/sources.nix;
in

(
  _final: prev: {
    inherit (prev.callPackage sources.niv {}) niv;
  }
)
