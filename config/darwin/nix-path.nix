{ lib, ... }:

{
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    darwin = toString <darwin>;
    nixpkgs = toString <nixpkgs>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
    darwin-config = toString <darwin-config>;
  };
}
