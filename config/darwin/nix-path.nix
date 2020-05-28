{ lib, ... }:

{
  # NOTE: If `environment.darwinConfig` is _not_ set, then nix-darwin defaults
  # to some location in the home directory
  #
  # If it's set _in addition to_ `darwin-config` on the NIX_PATH, then
  # duplicate entries will be present
  environment.darwinConfig = toString <darwin-config>;
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    darwin = toString <darwin>;
    nixpkgs = toString <nixpkgs>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
  };
}
