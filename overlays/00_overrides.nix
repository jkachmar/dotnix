# Overrides from the nixpkgs unstable channel.
{
  # Tracks nixos/nixpkgs-channels unstable branch.
  #
  # Try to pull new/updated packages from 'unstable' whenever possible, as
  # these will likely have cached results from the last successful Hydra
  # jobset.
  nixpkgs-unstable

  #   # Tracks nixos/nixpks main branch.
  #   #
  #   # Only pull from 'trunk' when channels are blocked by a Hydra jobset failure
  #   # or the 'unstable' channel has not otherwise updated recently for some other
  #   # reason.
  # , nixpkgs-trunk
, ...
}:

let
  unstable = import nixpkgs-unstable {};
  # trunk = import trunk {};
}:

final: prev:

in

_final: prev: {
  emacsMacport = unstable.emacsMacport;

  gitAndTools = (prev.gitAndTools or {}) // {
    delta = unstable.gitAndTools.delta;
  };

  lorri = unstable.lorri;
}
