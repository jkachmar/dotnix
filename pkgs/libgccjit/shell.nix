let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-unstable {};
  libgccjit = import ./default.nix { gcc = pkgs.gcc10; };
in

pkgs.mkShell {
  buildInputs = [ libgccjit ];
}
