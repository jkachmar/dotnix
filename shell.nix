{ sources ? import ./nix/sources.nix }:

let
  # TODO: Update this if the architectures diverge.
  isDarwin =
    builtins.any
      (arch: builtins.currentSystem == arch)
      [ "x86_64-darwin" ];

  machineName = (import ./current-machine {}).networking.hostName;
  pkgSrc = builtins.trace machineName (
    if isDarwin
    then builtins.trace "darwin" sources.nixpkgs-darwin
    else builtins.trace "nixos" sources.nixpkgs-nixos
  );

  pkgs = import pkgSrc {};

  #############################################################################

  niv = (pkgs.callPackage sources.niv {}).niv;

  nix-linter = (pkgs.callPackage sources.nix-linter {}).nix-linter;

  #############################################################################

  files = "$(find . -not -path './nix/*' -name '*.nix')";

  lint = pkgs.writeShellScriptBin "lint" "nix-linter ${files}";

  format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt ${files}";

  #############################################################################

  build-nix-path-env-var = path:
    builtins.concatStringsSep ":" (
      pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
    );

  nix-path-nixos = build-nix-path-env-var {
    nixpkgs = pkgSrc;
    # TODO: Evaluate if this is actually useful now that overlays are being
    # manually applied 
    # nixpkgs-overlays = "$dotfiles/overlays";
    nixos-config = "$dotfiles/current-machine";
  };

  nix-path-darwin = build-nix-path-env-var {
    darwin = sources.nix-darwin;
    nixpkgs = pkgSrc;
    # TODO: Evaluate if this is actually useful now that overlays are being
    # manually applied 
    # nixpkgs-overlays = "$dotfiles/overlays";
    darwin-config = "$dotfiles/current-machine";
  };

  nix-path = if isDarwin
  then nix-path-darwin
  else nix-path-nixos;

  set-nix-path = ''
    export dotfiles="${builtins.toPath ./.}"
    export NIX_PATH="${nix-path}"
  '';

  #############################################################################

  nixos-rebuild-cmd = pkgs.writeShellScript "nixos-rebuild-cmd" ''
    ${set-nix-path}
    nixos-rebuild ''${1-switch} --show-trace
  '';

  darwin-rebuild-cmd = pkgs.writeShellScript "darwin-rebuild-cmd" ''
    ${set-nix-path}
    $(nix-build '<darwin>' -A system --no-out-link --show-trace)/sw/bin/darwin-rebuild ''${1-switch} --show-trace
  '';

  rebuild-cmd = if isDarwin
  then darwin-rebuild-cmd
  else nixos-rebuild-cmd;
  # else pkgs.writeShellScriptBin "" "sudo -i ${nixos-rebuild-cmd}";

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    ${lint}/bin/lint
    ${format}/bin/format

    sudo -i ${rebuild-cmd} $1
  '';

  collect-garbage =
    pkgs.writeShellScriptBin "collect-garbage" ''
      nix-collect-garbage -d
    '';

  #############################################################################

in

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.nixpkgs-fmt

    niv
    nix-linter

    lint
    format

    rebuild
    collect-garbage
  ];
}
