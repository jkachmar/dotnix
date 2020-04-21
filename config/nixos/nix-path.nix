{ lib, ... }:

{
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    nixpkgs = toString <nixpkgs>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
    nixos-config = toString <nixos-config>;
  };
}
