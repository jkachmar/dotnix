#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, ... }:

{
  # Use Podman to run OCI containers.
  #
  # TODO: Factor OCI container backend configuration out to a more generic
  # module if/when more OCI-based services are added.
  virtualisation.oci-containers.backend = "podman";

  # TODO: Factor pod state persistence out to a more generic module if/when
  # more OCI-based services are added.
  environment.persistence."/state/podman" = {
    directories = [ "/var/lib/cni" ];
  };

  # FIXME: Documentation.
  environment.etc."containers/storage.conf".text = ''
    [storage]
    driver = "zfs"
    graphroot = "/state/podman/containers"

    [storage.options.zfs]
    mountopt="nodev"
  '';

  # Firewall settings.
  networking.firewall = {
    # TODO: Remap `80` and `443` at some point; this is for a
    # general-purpose server and it's dumb that PiHole hijacks these ports.
    allowedTCPPorts = [ 53 80 443 ];
    allowedUDPPorts = [ 53 ];
    # The NixOS firewall is conservative by default, so these ports must be
    # explicitly allowed in order for the PiHole to listen on `5053` (which
    # should be configured to supply local DNS resolution from
    # `dnscrypt-proxy`) .
    interfaces.docker0 = {
      allowedTCPPorts = [ 5053 ];
      allowedUDPPorts = [ 5053 ];
    };
  };

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "80:80"
      "443:443"
    ];
    volumes = [
      "/state/dns/pihole:/etc/pihole/"
      "/state/dns/dnsmasq.d:/etc/dnsmasq.d/"
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
