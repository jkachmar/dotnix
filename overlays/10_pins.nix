# Packages that are pinned with newer (or different) versions than are present
# in the nixpkgs package tree.
{ niv
, ...
}:

_final: prev: {
  inherit (prev.callPackage niv {}) niv;
}
