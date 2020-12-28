{ sources ? import ./nix/sources.nix }:
let
  # TODO: Update this if the architectures diverge.
  isDarwin =
    builtins.any
      (arch: builtins.currentSystem == arch)
      [ "x86_64-darwin" ];

  # FIXME: This bit with 'lib = null' is a hack to just pull the hostName out.
  #
  # The config is never evaluated in this step; consider just extracting
  # hostname to its own file.
  machineName = (import ./current-machine { lib = null; }).networking.hostName;
  pkgSrc = builtins.trace machineName (
    if isDarwin
    then builtins.trace "darwin" sources.darwin-stable
    else builtins.trace "nixos" sources.nixos-stable
  );

  pkgs = import pkgSrc { };

  #############################################################################

  # nix-linter = (pkgs.callPackage sources.nix-linter {}).nix-linter;

  #############################################################################

  files = "$(find . -not -path './nix/*' -not -path './pkgs/node-packages/*' -name '*.nix')";

  # lint = pkgs.writeShellScriptBin "lint" "nix-linter ${files}";

  format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt ${files}";

  #############################################################################

  build-nix-path-env-var = path:
    builtins.concatStringsSep ":" (
      pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
    );

  nix-path-nixos = build-nix-path-env-var {
    nixos-config = "$dotfiles/current-machine";
    nixpkgs = pkgSrc;
    # TODO: Evaluate if this is actually useful now that overlays are being
    # manually applied 
    # nixpkgs-overlays = "$dotfiles/overlays";
  };

  nix-path-darwin = build-nix-path-env-var {
    darwin = sources.nix-darwin;
    darwin-config = "$HOME/.config/dotfiles/current-machine";
    nixpkgs = pkgSrc;
    # TODO: Evaluate if this is actually useful now that overlays are being
    # manually applied 
    # nixpkgs-overlays = "$dotfiles/overlays";
  };

  nix-path =
    if isDarwin
    then nix-path-darwin
    else nix-path-nixos;

  set-nix-path = ''
    export NIX_PATH="${nix-path}"
  '';

  #############################################################################

  nixos-rebuild-cmd = pkgs.writeShellScript "nixos-rebuild-cmd" ''
    function nixos_rebuild_impl {
      ${set-nix-path}
      nixos-rebuild ''${1-switch} --show-trace
    }
    sudo nixos_rebuild_impl
  '';

  darwin-rebuild-cmd = pkgs.writeShellScript "darwin-rebuild-cmd" ''
    ${set-nix-path}
    $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild ''${1-switch} --show-trace
  '';

  rebuild-cmd =
    if isDarwin
    then darwin-rebuild-cmd
    else nixos-rebuild-cmd;

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    ${format}/bin/format

    ${rebuild-cmd} $1
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
    pkgs.niv

    # nix-linter

    # lint
    format

    rebuild
    collect-garbage
  ];

  shellHook = ''
    export NIX_PATH="${nix-path}"
  '';
}
