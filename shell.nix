# { machine ? "crazy-diamond"
{ sources ? import ./nix/sources.nix
}:

let
  # FIXME: Code duplication; cf. `shell.nix`.
  # TODO: Make this better...
  #
  # Hardcoded list of darwin machine names.
  darwinMachines = [ "crazy-diamond" ];
  machineName = (import ./current-machine {}).networking.hostName;
  isDarwin =
    builtins.any
      (darwinMachineName: machineName == darwinMachineName)
      (builtins.trace machineName darwinMachines);

  pkgSrc = if isDarwin
  then builtins.trace "darwin" sources.nixpkgs-darwin
  else builtins.trace "nixos" sources.nixpkgs-nixos;

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
    nixpkgs-overlays = "$dotfiles/overlays";
    nixos-config = "$dotfiles/current-machine";
  };

  nix-path-darwin = build-nix-path-env-var {
    darwin = sources.nix-darwin;
    nixpkgs = pkgSrc;
    nixpkgs-overlays = "$dotfiles/overlays";
    darwin-config = "$dotfiles/current-machine";
  };

  nix-path = if isDarwin
  then nix-path-darwin
  else nix-path-nixos;

  set-nix-path = ''
    export dotfiles="$(nix-build --no-out-link)"
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

  # It's important that _all of_ 'rebuild-root-cmd' be executed under 'sudo'
  # so that the $NIX_PATH is set appropriately
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    ${lint}/bin/lint
    ${format}/bin/format

    sudo ${rebuild-cmd} $1
  '';

  collect-garbage =
    pkgs.writeShellScriptBin "collect-garbage" "sudo nix-collect-garbage -d";

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
