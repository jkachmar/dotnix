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

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  #
  # $ darwin-rebuild changelog

  nix = {
    # This replicates some of the nix.conf settings configured in
    # '$dotfiles/config/common/nix/default.nix'.
    #
    # Those are user-level settings, which diverge (slightly) from system-level
    # settings (which are slightly different between NixOS and nix-darwin).
    #
    # XXX: Should the binary caches be added here, as well, so that system-level
    # packages can pull from them?
    #
    # NOTE: Keep this in sync with '$dotfiles/nixos/darwin/nix.nix'
    extraOptions = ''
      # Keep GC roots associated with nix-shell from being cleaned
      gc-keep-derivations = true
      gc-keep-outputs = true
    '';

    # TODO: This one seems iffy...
    # # Run the collector automatically every 10 days.
    # options = "--delete-older-than 10d";

    # Auto-upgrade Nix package.
    package = pkgs.nix;
  };

  # NOTE: If `environment.darwinConfig` is _not_ set, then nix-darwin defaults
  # to some location in the home directory
  #
  # If it's set _in addition to_ `darwin-config` on the NIX_PATH, then
  # duplicate entries will be present
  environment.darwinConfig = toString <darwin-config>;
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    darwin = toString <darwin>;
    nixpkgs = toString <nixpkgs>;
    # TODO: Evaluate if this is actually useful now that the overlays are being
    # set in ./default.nix
    # nixpkgs-overlays = toString <nixpkgs-overlays>;
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
