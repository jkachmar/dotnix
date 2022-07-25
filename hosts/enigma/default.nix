{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports = [
    # NixOS base configuration profile.
    ../../profiles/nixos/base.nix

    # Podman-based OCI virtualization configuration.
    ../../config/system/nixos/podman.nix

    # Home server service configuration.
    #
    # NOTE: Didn't end up using either of these very much.
    # ../../config/services/clickhouse.nix
    # ../../config/services/metabase.nix
    ../../config/services/nginx.nix
    ../../config/services/dns/ddclient.nix
    ../../config/services/dns/dnscrypt-proxy.nix
    ../../config/services/dns/pihole.nix
    ../../config/services/downloads/sabnzbd.nix
    ../../config/services/media/hardware-acceleration.nix
    ../../config/services/media/plex
    ../../config/services/media/handbrake.nix
    ../../config/services/media/radarr.nix
    ../../config/services/media/sonarr.nix

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

    # The primary user should be able to:
    #  - administrate all media & downloads
    #  - manage data & analytics
    extraGroups = [ "analytics" "downloads" ];

    # FIXME: Change this to a different password from the root user.
    # TODO: Source this from a file in '/secrets'.
    initialHashedPassword =
      "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";

    # TODO: Extract this out into some shared set of known public keys.
    openssh.authorizedKeys.keys = [
      # crazy-diamond
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrZAwektbexTFUtSn0vuCHP6lvTvA/jdOb+SF5TD9VA me@jkachmar.com"

      # crazy-diamond (secure enclave)
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNUZg7/DH/FzbiTz7nqP+KfsxIRRd0N2SplekG7EF2xwAxnFvcR/uoXf6dcbYFO14GCd/myHWXJzeGuxq/ihOkE= enigma@secretive.crazy-diamond.local"

      # king-crimson
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL3PuktGRn+WCiNAAKuUVSB6XJuwAmRm/IPd6y9VD9yrd2F1TLMsB5v3RHrStaVVbHmITp4s+QrfyXXgQKh43e8= king-crimson"

      # star-platinum
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJxSLTsCtr8JW1XgP+cqx6+iAI1VzJVjU/LR5nkNcEY star-platinum"

      # wonder-of-u
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCQ2KyPZfXYoVPVlRLNFUHIAWkmQ4Tgqlq7m6l0z5R8TgOmoV+2CyhEjHcUvUs6ra4O7ZjB3PwM+xCx/FtCX+I0= wonder-of-u"
    ];

    home-manager.home.packages = with pkgs; [
      bind.dnsutils
      qrencode # Useful for generating wireguard QR codes.
      wireguard-tools
    ];
  };

  # Enable `mosh` server; opens UDP ports 60000 - 61000;
  programs.mosh.enable = true;

  # Enable SFTP (required for Blink Shell VS Code).
  services.openssh.allowSFTP = true;

  #############################################################################
  # Global persistence.
  #############################################################################

  environment.etc = {
    # TODO: Check if this can use the `home-manager` XDG home stuff.
    "nixos".source = "${config.primary-user.home.directory}/.config/dotfiles";
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
      eno1 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
      wlp0s20f3.useDHCP = true;
    };

    firewall = {
      enable = true;

      # Wireguard.
      allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];
      trustedInterfaces = [ "wg0" ];
    };
  };

  # Wireguard server.
  #
  # TODO: Extract this (and the above firewall settings) out into a module.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.nat = {
    enable = true;
    externalInterface = "eno1";
    internalInterfaces =
      builtins.attrNames config.networking.wireguard.interfaces;
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/secrets/wireguard/enigma/private";

      peers = [
        {
          # crazy-diamond | MacBook Pro
          publicKey = "HSnaUa1oJ4NDjbgAOnsgns4gvbkup5BFdNmSBMx4VSg="; # /secrets/wireguard/crazy-diamond/public
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # king-crimson | iPhone
          publicKey = "lpfz2jYXuiv5qbD+VmIvLOKqLreb7no/gM9qQQWUHl4="; # /secrets/wireguard/king-crimson/public
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          # manhattan-transfer | MacBook Pro
          publicKey = "DfNLbTY465mT+m+Nw1X4MJxDPIWzP/cPvXA/FYc/rS4="; # /secrets/wireguard/manhattan-transfer/public
          allowedIPs = [ "10.100.0.4/32" ];
        }
        {
          # wonder-of-u | iPad Mini
          publicKey = "X7KUdq+6fHFuyY81BLtKG6LUNQOmOHdtGzhDQRxC4yw="; # /secrets/wireguard/wonder-of-u/public
          allowedIPs = [ "10.100.0.5/32" ];
        }
      ];

      # This allows the wireguard server to route your traffic to the internet
      # and hence be like a VPN.
      #
      # For this to work you have to set the dnsserver IP of your router (or
      # dnsserver of choice) in your clients.
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eno1 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eno1 -j MASQUERADE
      '';
    };
  };

  # Wireguard should wait to start until after the 'secrets' directory has
  # been mounted (it needs to access keys).
  systemd.services.wireguard-wg0 = {
    after = [ "secrets.mount" ];
    requires = [ "secrets.mount" ];
  };

  # NOTE: Necessary to set this here because the clickhouse module sets a
  # default time zone.
  time.timeZone = "America/New_York";

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
