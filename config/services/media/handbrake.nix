#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "handbrake.${hostName}.${domain}";
  port = "7001";
in
{
  #############################################################################
  # Handbrake.
  #############################################################################
  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;
    };
  };

  virtualisation.oci-containers.containers.handbrake = {
    image = "jlesage/handbrake:latest";
    ports = [
      "${port}:5800"
    ];
    # TODO: The storage, watch, and output directories should probably live on
    # the NAS.
    volumes = [
      "/persist/handbrake/config:/config:rw"
      "/persist/handbrake/storage:/storage:ro"
      "/persist/handbrake/watch:/watch:rw"
      "/persist/handbrake/output:/output:rw"
    ];
    extraOptions = [
      "--device=/dev/dri:/dev/dri:rwm"
    ];
    autoStart = true;
  };
  systemd.services.podman-handbrake = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
}
