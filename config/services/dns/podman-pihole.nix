#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, pkgs, ... }:

{
  #############################################################################
  # VIRTUALIZATION
  #############################################################################

  # Use Podman to run OCI containers.
  #
  # TODO: Factor OCI container backend configuration out to a more generic
  # module if/when more OCI-based services are added.
  virtualisation = {
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
  environment.etc."containers/storage.conf".text = ''
    [storage]
    driver = "zfs"
    graphroot = "/persist/podman/containers"

    [storage.options.zfs]
    mountopt="nodev"
  '';

  #############################################################################
  # NETWORKING
  #############################################################################

  # TODO: See if this is still necessary now that `dnscrypt-proxy` supports
  # bootstrap resolvers.
  networking.nameservers = [ "127.0.0.1" "9.9.9.9" ];

  # Firewall settings.
  networking.firewall = {
    allowedTCPPorts = [ 53 7000 7001 ];
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

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "80:7000"
      "443:7001"
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
      # TODO: Change this to something secure, obviously.
      WEBPASSWORD = "hunter2";
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
