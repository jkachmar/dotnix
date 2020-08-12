# Packages that are pinned with Niv newer (or different) versions than are in
# the nixpkgs (stable or unstable) package tree.
let
  sources = import ../nix/sources.nix;
in

(
  _self: super: {
    inherit (super.callPackage sources.niv {}) niv;
  }
)
