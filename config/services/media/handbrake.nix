#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, pkgs, ... }:

let
  inherit (config.networking) fqdn;
  port = "7001";
in
{
  #############################################################################
  # Handbrake.
  #############################################################################
  services.nginx.virtualHosts."handbrake.${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
    locations."/websockify" = {
      proxyPass = "http://127.0.0.1:${port}/websockify";
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
      "/mnt/moodyblues/media:/media:ro"
      "/persist/handbrake/config:/config:rw"
      "/persist/handbrake/storage:/storage:ro"
      "/persist/handbrake/watch:/watch:rw"
      "/persist/handbrake/output:/output:rw"
    ];
    extraOptions = [
      "--device=/dev/dri:/dev/dri:rwm"
      "--label=\"io.containers.autoupdate=registry\""
    ];
    autoStart = true;
  };
  systemd.services.podman-handbrake = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
}
