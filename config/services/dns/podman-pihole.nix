#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
in
{
  #############################################################################
  # VIRTUALIZATION
  #############################################################################

  # Use Podman to run OCI containers.
  #
  # TODO: Factor OCI container backend configuration out to a more generic
  # module if/when more OCI-based services are added.
  virtualisation = {
    containers = {
      enable = true;
      storage.settings.storage = {
        driver = "zfs";
        graphroot = "/persist/podman/containers";
        runroot = "/run/containers/storage";
      };
    };

    podman = {
      enable = true;
      # NOTE: Workaround for https://github.com/NixOS/nixpkgs/pull/112443
      extraPackages = [ pkgs.zfs ];
    };

    oci-containers.backend = "podman";
  };

  # TODO: Factor pod state persistence out to a more generic module if/when
  # more OCI-based services are added.
  systemd.tmpfiles.rules = [
    "L /var/lib/cni - - - - /persist/var/lib/cni"
  ];

  # FIXME: Documentation.
#   environment.etc."containers/storage.conf".text = ''
#     [storage]
#     driver = "zfs"
#     graphroot = "/persist/podman/containers"
# 
#     [storage.options.zfs]
#     mountopt="nodev"
#   '';

  #############################################################################
  # NETWORKING
  #############################################################################

  # TODO: See if this is still necessary now that `dnscrypt-proxy` supports
  # bootstrap resolvers.
  networking.nameservers = [ "127.0.0.1" "::1" ];

  # Firewall settings.
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];

    # Open up ports on the "cni-podman0" bridge network.
    #
    # The NixOS firewall is conservative by default, so these ports must be
    # explicitly allowed in order for the PiHole to listen on `5053` (which
    # should be configured to supply local DNS resolution from
    # `dnscrypt-proxy`) .
    interfaces.cni-podman0 = {
      allowedTCPPorts = [ 5053 ];
      allowedUDPPorts = [ 5053 ];
    };
  };

  #############################################################################
  # PIHOLE
  #############################################################################

  services.nginx.virtualHosts."pihole.${fqdn}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/".proxyPass = "http://localhost:7000";
  };

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "7000:80"
    ];
    volumes = [
      "/persist/etc/pihole:/etc/pihole/"
      "/persist/etc/dnsmasq.d:/etc/dnsmasq.d/"
    ];
    # TODO: Set `dnscrypt-proxy` resolver using an environment variable.
    environment = {
      DNS1 = "10.88.0.1#5053";
      REV_SERVER = "true";
      REV_SERVER_TARGET = "10.0.0.1"; # Router IP.
      REV_SERVER_CIDR = "10.0.0.0/16";
      TZ = config.time.timeZone;
      PROXY_LOCATION = "pihole";
      # NOTE: This must agree with the nginx virtual host.
      VIRTUAL_HOST = "pihole.${fqdn}";
      # TODO: Change this to something secure, obviously.
      WEBPASSWORD = "hunter2";
      # NOTE: cf. https://discourse.pi-hole.net/t/safari-wont-finish-loading-certain-sites-after-ios-15-5-macos-12-4-upgrade/55516/21
      BLOCK_ICLOUD_PR = "false";
    };
    extraOptions = [ "--dns=127.0.0.1" "--dns=9.9.9.9" ];
    workdir = "/etc/pihole";
    autoStart = true;
  };
  systemd.services.podman-pihole = {
    after = [ "network.target" ];
    wants = [ "dnscrypt-proxy2.service" ];
    wantedBy = [ "multi-user.target" ];
  };
}
