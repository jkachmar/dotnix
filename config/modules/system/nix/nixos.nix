###############################################################################
# NixOS-specific Nix system configuration.
###############################################################################
{ lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isLinux;
in

mkIf isLinux {
  nix = {
    # Darwin sandboxing is still broken.
    # https://github.com/NixOS/nix/issues/2311
    #
    # Unify this once everything works again.
    useSandbox = true;

    nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
      nixos-config = toString <nixos-config>;
      nixpkgs = pkgs.path;
      unstable = pkgs.unstable.path;
      trunk = pkgs.trunk.path;
    };

    # # TODO: This one seems iffy...
    # gc = {
    #   # Automatically run the Nix garbage collector daily.
    #   automatic = true;
    #   dates = "daily";
    #   # Run the collector automatically every 10 days.
    #   options = "--delete-older-than 10d";
    # };
  };
}
