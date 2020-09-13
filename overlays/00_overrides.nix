# Overrides from the nixpkgs unstable channel.
let
  sources = import ../nix/sources.nix;

  # Tracks nixos/nixpkgs-channels unstable branch.
  #
  # Try to pull new/updated packages from 'unstable' whenever possible, as
  # these will likely have cached results from the last successful Hydra
  # jobset.
  unstable = import sources.nixpkgs-unstable {};

  # Tracks nixos/nixpks main branch.
  #
  # Only pull from 'trunk' when channels are blocked by a Hydra jobset failure
  # or the 'unstable' channel has not otherwise updated recently for some other
  # reason.
  # trunk = import sources.nixpkgs-trunk {};
in

(
  final: prev: {
    emacsMacport = unstable.emacsMacport;
    gitAndTools = (prev.gitAndTools or {}) // {
      delta = unstable.gitAndTools.delta;
    };
    lorri = unstable.lorri;
  }
)
