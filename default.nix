{ sources ? import ./sources.nix }:

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
      darwinMachines;

  pkgSrc = if isDarwin
  then sources.nixpkgs-darwin
  else sources.nixpkgs-nixos;

  pkgs = import pkgSrc {};

  excludeGit = builtins.filterSource (
    path: type:
      type != "directory" || baseNameOf path != ".git"
  );
in

pkgs.stdenv.mkDerivation {
  name = "dotfiles";
  src = excludeGit ./.;
  phases = [ "unpackPhase" ];
  unpackPhase = "cp -r $src $out";
}
