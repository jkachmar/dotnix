{ config, inputs, pkgs, ... }:

let
  #############################################################################

  build-nix-path-env-var = path:
    builtins.concatStringsSep ":" (
      pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
    );

  darwin-nix-path = build-nix-path-env-var {
    inherit (inputs) darwin unstable;
    darwin-config = config;
    nixpkgs = pkgs.path;
  };

  nixos-nix-path = build-nix-path-env-var {};

  nix-path = if pkgs.stdenv.isDarwin
    then darwin-nix-path
    else nixos-nix-path;

  #############################################################################

in

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.nixFlakes
    pkgs.nixpkgs-fmt
    pkgs.niv
  ];
  shellHook = ''
    export NIX_PATH="${nix-path}"
  '';
}
