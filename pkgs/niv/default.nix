{ callPackage }:

let
  sources = import ../../nix/sources.nix;
in

(callPackage sources.niv {}).niv
