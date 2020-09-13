{ ... }:

let
  sources = import ../../nix/sources.nix;
in

{
  imports = [
    "${sources.home-manager}/nix-darwin"
    ./hardware.nix
    ../../config/nix
    ../../modules/nix
    ../../modules/desktop
    ../../modules/development
  ];

  primary-user.email = "me@jkachmar.com";
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = "jkachmar";
  networking.hostName = "crazy-diamond";

  # NOTE: If `environment.darwinConfig` is _not_ set, then nix-darwin defaults
  # to some location in the home directory
  #
  # If it's set _in addition to_ `darwin-config` on the NIX_PATH, then
  # duplicate entries will be present
  environment.darwinConfig = ./.;

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
