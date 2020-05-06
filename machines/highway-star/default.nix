{ ... }:

let
  sources = import ../../nix/sources.nix;
in

{
  imports = [
    ./hardware.nix
    "${sources.home-manager}/nix-darwin"
    ../../modules/darwin
    ../../config/common
    ../../config/darwin
  ];

  primary-user.name = "jkachmar";
  networking.hostName = "highway-star";

  #############################################################################
  # Machine-specific time settings
  #
  # TODO: Perhaps this should be moved up to `../../config/common` since it's
  # very unlikely that my configuration will span multiple time zones.
  time.timeZone = "America/New_York";

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
