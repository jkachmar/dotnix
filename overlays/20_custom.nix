# Custom packages that are not currently provided within the nixpkgs package
# tree.
let
  sources = import ../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable {};
in

(
  _: _: {
    libgccjit = import ../pkgs/libgccjit { gcc = unstable.gcc10; };
  }
)
