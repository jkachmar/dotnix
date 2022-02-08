{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports = [
    # NixOS desktop configuration profile.
    ../../profiles/nixos/desktop.nix
    # Machine-specific hardware configuration.
    ./hardware.nix
  ];

  #############################################################################
  # Machine-specific global packages.
  #############################################################################
  environment.systemPackages = with pkgs; [
    # NOTE: Something's messed up with the Blue Yeti Nano, so its gain needs
    # to be manually adjusted.
    #
    # TODO: Look into 'pipewire' as an alternative to 'pulseaudio' which might
    # help improve the overall audio situation...
    #
    # ...or just ditch Linux and switch back to macOS, the desktop experience
    # is absolutely fucking miserable.
    pavucontrol
  ];

  #############################################################################
  # System user configuration.
  #############################################################################
  # TODO: All deploys should use immutable users where possible, so this
  # should be a part of the base nixos config module.
  users.mutableUsers = false;

  # FIXME: Change this to a different password from the `primary-user`.
  # TODO: Source this from a file in '/secrets'.
  users.users.root.initialHashedPassword =
    "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";

  #############################################################################
  # Primary user configuration.
  #############################################################################
  primary-user = {
    name = "jkachmar";
    git.user.name = config.primary-user.name;
    git.user.email = "git@jkachmar.com";

    # FIXME: Change this to a different password from the root user.
    # TODO: Source this from a file in '/secrets'.
    initialHashedPassword =
      "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";
  };

  #############################################################################
  # Global persistence.
  #############################################################################

  environment.etc = {
    # TODO: Check if this can use the `home-manager` XDG home stuff.
    "nixos".source = "${config.primary-user.home.directory}/.config/dotfiles";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";
    "docker/key.json".source = "/persist/etc/docker/key.json";

    # Necessary to build GraphQL Engine with MSSQL support.
    #
    # NOTE: Ensure that the shell config for the GraphQL Engine repo uses the
    # same package set as the system to source the ODBC driver stuff.
    "odbcinst.ini".text = ''
      [ODBC Driver 17 for SQL Server]
      Driver          = ${pkgs.unixODBCDrivers.msodbcsql17}/lib/libmsodbcsql-17.7.so.1.1
    '';
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    "L /var/lib/docker    - - - - /persist/var/lib/docker"
  ];

  #############################################################################
  # Machine identification.
  #############################################################################
  # TODO: Source the following two values from files in '/persist'.
  networking.hostId = "68210a0b"; # Required by ZFS.
  environment.etc."machine-id".text = "0aaab60e7c4a49d49c953e4972dbe443";

  #############################################################################
  # Networking.
  #############################################################################
  networking = {
    hostName = "star-platinum";

    firewall.enable = true;
    interfaces = {
      enp4s0.useDHCP = true;
      # This machine is now hardwired.
      # wlp5s0.useDHCP = true;
    };
    networkmanager.enable = true;

    wireguard.interfaces.wg0 = {
      generatePrivateKeyFile = true;
      privateKeyFile = "/secrets/wireguard/wg0";
    };
  };

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
  system.stateVersion = "21.11";
}
