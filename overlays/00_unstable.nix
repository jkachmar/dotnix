# Overrides from the nixpkgs unstable channel.
let
  sources = import ../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable {};
in

(
  _: _: {
    lorri = unstable.lorri;
  }
)
