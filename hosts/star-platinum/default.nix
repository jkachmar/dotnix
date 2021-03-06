{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports = [
    # NixOS desktop configuration profile.
    ../../profiles/nixos/desktop.nix
    # Machine-specific hardware configuration.
    ./hardware.nix
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
    home-manager.imports = [ "${inputs.impermanence}/home-manager.nix" ];
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
    "nixos".source = "/persist/etc/nixos";
  	"NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";
    "docker/key.json".source = "/persist/etc/docker/key.json";
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
      wlp5s0.useDHCP = true;
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
  system.stateVersion = "21.05";
}
