{ ... }:

{
  imports = [
    ./hardware.nix
    ../../config/nix
    ../../modules/nix
    ../../modules/desktop
    ../../modules/development
  ];

  # primary-user.email = ""; # TODO: store this in secrets
  primary-user.fullname = "Joe Kachmar";
  # primary-user.username = ""; # TODO: store this in secrets
  networking.hostName = "highway-star";

  ###############################################################################
  # Machine-specific, user-level configuration.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [ awscli ];
  };


  # This machine _must_ be run in single-user mode, so we cannot take advantage
  # of the Nix daemon.
  services.nix-daemon = {
    enable = false;
    enableSocketListener = false;
  };

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
