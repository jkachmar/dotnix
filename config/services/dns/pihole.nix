#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "pihole.${hostName}.${domain}";
in
{
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

  services.nginx.virtualHosts."${fqdn}" = {
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
      REV_SERVER_TARGET = "192.168.0.1"; # Router IP.
      REV_SERVER_CIDR = "192.168.0.0/16";
      TZ = config.time.timeZone;
      PROXY_LOCATION = "pihole";
      VIRTUAL_HOST = fqdn;
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
