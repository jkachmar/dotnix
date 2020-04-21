{ ... }:

let
  sources = import ../../sources.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    "${sources.home-manager}/nixos"
    ../../modules/nixos
    ../../config/common
    ../../config/nixos
  ];

  primary-user.name = "jkachmar";
  networking.hostName = "star-platinum";

  #############################################################################
  # Machine-specific time settings
  #
  # TODO: Although the `hardwareClockInLocalTime` setting is specific to this
  # machine (since it's required for dual-booting with windows), perhaps
  # `timeZone` should be moved up to `../../config/common` since it's very
  # unlikely that my machines will span multiple time zones.
  time = {
    hardwareClockInLocalTime = true; # Required for Windows
    timeZone = "America/New_York";
  };

  #############################################################################
  # Machine-specific networking configuration
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
    interfaces.wlp5s0.useDHCP = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
