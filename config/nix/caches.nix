###############################################################################
# Nix binary cache configuration.
###############################################################################
let
  mkCache = url: key: { inherit url key; };

  default = mkCache
    "https://cache.nixos.org"
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";

  nix-community = mkCache
    "https://nix-community.cachix.org"
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  caches = [
    default
    nix-community
  ];
in
{
  substituters = builtins.map (cache: cache.url) caches;
  keys = builtins.map (cache: cache.key) caches;
}
