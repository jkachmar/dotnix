{ lib, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
in

{
  imports = [
    # nix-darwin version of home-manager.
    "${sources.home-manager}/nix-darwin"
  ];

  # TODO: Should nix-darwin manage the default OS-shell?
  # # Install and configure system shells.
  # environment.shells = [ pkgs.fish ];

  nix = {
    # TODO: This one seems iffy...
    # # Run the collector automatically every 10 days.
    # options = "--delete-older-than 10d";

    # Auto-upgrade Nix package.
    package = pkgs.nix;
  };

  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    darwin = sources.nix-darwin;
    nixpkgs = sources.nixpkgs-darwin;
    nixpkgs-overlays = ../../overlays;
  };

  # Auto-upgrade the daemon service.
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
  };

  # TODO: Investigate why this disables home-manager configuration settings.
  #
  # This probably has something to do with hm-session-vars

  # # Install per-user packages.
  # home-manager.useUserPackages = true;
}
