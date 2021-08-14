{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports = [
    # NixOS base configuration profile.
    ../../profiles/nixos/base.nix

    # Home server service configuration.
    ../../config/services/nginx.nix
    ../../config/services/dns/ddclient.nix
    ../../config/services/dns/dnscrypt-proxy.nix
    ../../config/services/dns/podman-pihole.nix
    ../../config/services/media/hardware-acceleration.nix
    ../../config/services/media/plex
    ../../config/services/downloads/sabnzbd.nix

    # Machine-specific hardware configuration.
    ./hardware.nix
  ];

  #############################################################################
  # System user configuration.
  #############################################################################
  # XXX: Would it be better to explicitly add 'NOPASSWD' for my username in
  # 'security.sudo.extraRules'?
  security.sudo.wheelNeedsPassword = false;

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
    email = "me@jkachmar.com";
    git.user.name = config.primary-user.name;
    git.user.email = "git@jkachmar.com";

    # The primary user should be able to administrate all media & downloads.
    extraGroups = [ "downloads" ];

    # FIXME: Change this to a different password from the root user.
    # TODO: Source this from a file in '/secrets'.
    initialHashedPassword =
      "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";

    # TODO: Extract this out into some shared set of known public keys.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrZAwektbexTFUtSn0vuCHP6lvTvA/jdOb+SF5TD9VA me@jkachmar.com"
    ];

    home-manager.home.packages = with pkgs; [
      bind.dnsutils
    ];
  };

  #############################################################################
  # Global persistence.
  #############################################################################

  environment.etc = {
    "nixos".source = "/persist/etc/nixos";
  };

  #############################################################################
  # Machine identification.
  #############################################################################
  # TODO: Source the following two values from files in '/persist'.
  networking.hostId = "8425e349"; # Required by ZFS.
  environment.etc."machine-id".text = "4b632b7bbd1940ecaceab8ecc74be662";

  #############################################################################
  # Networking.
  #############################################################################
  networking = {
    hostName = "enigma";
    domain = "thempire.dev";

    interfaces = {
      eno1.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };

    firewall = {
      enable = true;
      allowedUDPPorts = [
        # Wireguard.
        51820
      ];
    };
  };

  # Wireguard server.
  #
  # TODO: Extract this (and the above firewall settings) out into a module.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.wireguard = {
    enable = true;
    interfaces.enigma = {
      generatePrivateKeyFile = true;
      privateKeyFile = "/secrets/wireguard/enigma";

      ips = [ ];
      peers = [ ];
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
