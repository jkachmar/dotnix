{ ... }:

{
  imports = [
    ./hardware.nix
    ../../config/nix
    ../../modules/nix
    ../../config/common
    ../../config/darwin
  ];

  primary-user.email = ""; # TODO: store this in secrets
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = ""; # TODO: store this in secrets
  networking.hostName = "highway-star";

  ###############################################################################
  # Machine-specific, user-level configuration.
  primary-user.home-manager = {
    home.packages = with pkgs; [ awscli ];
  };

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
