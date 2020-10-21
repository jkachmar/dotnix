###############################################################################
# Misc. NixOS system configuration and user interface settings.
###############################################################################
{ pkgs, ... }:

{
  hardware = {
    # Enable bluetooth hardware support... 
    bluetooth = {
      enable = true;
      config = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    # ..as well as the required pulseaudio packages for bluetooth audio.
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
  };

  # Enable Kwallet auto-signin.
  security.pam.services.sddm.enableKwallet = true;

  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "nvidia" ];

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Enable touchpad support.
    libinput = {
      enable = true;
      accelSpeed = "0.1";
    };
  };

  # Enable sound.
  sound.enable = true;

  # Automatically upgrade NixOS version.
  #
  # NOTE: Is this really useful at all, since everything is pinned to exact
  # commits?
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };
}
