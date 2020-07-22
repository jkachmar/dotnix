{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../config/nix
    ../../modules/nix
    ../../config/common
    ../../config/nixos
  ];

  primary-user.email = "me@jkachmar.com";
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = "jkachmar";
  networking.hostName = "star-platinum";

  #############################################################################
  # Machine-specific time settings, required for Windows dual-boot.
  time.hardwareClockInLocalTime = true;

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
