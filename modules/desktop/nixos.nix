###############################################################################
# Desktop, sound, and graphics.
###############################################################################

{ pkgs, ... }:

{
  ###############################################################################
  # System-level configuration.
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

  # Enable bluetooth hardware support + required pulseaudio packages for
  # bluetooth audio.
  hardware.bluetooth = {
    enable = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Enable Kwallet auto-signin.
  security.pam.services.sddm.enableKwallet = true;

  # Automatically upgrade NixOS version.
  #
  # NOTE: Is this really useful at all, since everything is pinned to exact
  # commits?
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  ###############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    home.packages = with pkgs; with kdeApplications; [
      anki
      discord
      firefox
      irccloud
      signal-desktop
      slack
      spotify

      # KDE/Plasma packges
      ark
      kcalc
      kdeconnect
      kdeplasma-addons
      spectacle
    ];
  };
}
