#########################
# System Configuration. #
#########################
{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports =
    [
      ../../profiles/nixos/base.nix
      ./hardware.nix
    ];

  # Localization override.
  time.timeZone = "US/Mountain";

  ##########
  # Users. #
  ##########
  users = {
    mutableUsers = false;
    users.root.passwordFile = "/secrets/passwords/kraftwerk/root";
  };

  primary-user = {
    name = "jkachmar";
    git.user.name = config.primary-user.name;
    git.user.email = "git@jkachmar.com";
    passwordFile = "/secrets/passwords/kraftwerk/jkachmar";
    extraGroups = [ "docker" ];
  };

  #####################
  # Persistent state. #
  #####################
  environment.etc = {
    "nixos".source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source =
      "/persist/etc/NetworkManager/system-connections";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
  ];

  ###########################
  # Machine Identification. #
  ###########################
  networking.hostId = "38a2902a"; # For ZFS.
  environment.etc."machine-id".text = "67427c1da8394ba7b421e2e529d45d79";

  ###############
  # Networking. #
  ###############
  networking = {
    hostName = "kraftwerk";

    firewall.enable = true;
    interfaces = {
      wlp170s0.useDHCP = true;
      # enp0s13f0u2.useDHCP = true;
    };
    networkmanager.enable = true;
  };


  ############
  # Desktop. #
  ############

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  # Enable sound & bluetooth.
  sound.enable = true;
  hardware = {
    # Enable bluetooth...
    bluetooth = {
      enable = true;
      # https://wiki.archlinux.org/title/Bluetooth_headset#Apple_AirPods_have_low_volume
      disabledPlugins = [ "avrcp" ];
      settings = {
        General = {
          ControllerMode = "bredr"; # NOTE: Need this to connect to AirPods.
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  security.pam.services.jkachmar.enableKwallet = true;
  # Fingerprint reader support.
  services.fprintd.enable = true;

  #######################
  # Package management. #
  #######################
  environment.systemPackages = (with pkgs; [
    discord
    firefox
    signal-desktop
    slack
    vscode
    vim 
    wget
  ]) ++ (with unstable; [
    neovim
  ]);

  #############################################################################
  # System.
  #############################################################################
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  #
  # It‘s perfectly fine and recommended to leave this value at the release
  # version of the first install of this system.
  #
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}

