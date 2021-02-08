{ config-path, inputs, pkgs, ... }:
let
  build-nix-path-env-var = path:
    builtins.concatStringsSep ":" (
      pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
    );

  darwin-nix-path = build-nix-path-env-var {
    inherit (inputs) darwin unstable;
    darwin-config = config-path;
    nixpkgs = pkgs.path;
  };

  nixos-nix-path = build-nix-path-env-var { };

  nix-path =
    if pkgs.stdenv.isDarwin
    then darwin-nix-path
    else nixos-nix-path;

  #############################################################################

  files = "$(find . -not -path './nix/*' -not -path './pkgs/node-packages/*' -name '*.nix')";

  format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt ${files}";

in
pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.nixFlakes
    pkgs.nixpkgs-fmt
    pkgs.niv

    format
  ];
  shellHook = ''
    export NIX_PATH="${nix-path}"
  '';
}
