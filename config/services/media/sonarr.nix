{ config, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
in
{
  services.sonarr = {
    enable = true;
    group = "downloads";
    openFirewall = true;
  };

  # Ensure that sonarr waits for the downloads and media directories to be 
  # available.
  systemd.services.sonarr = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "mnt-moodyblues-downloads.mount"
      "mnt-moodyblues-media.mount"
    ];
  };

  services.nginx.virtualHosts."sonarr.${fqdn}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/".proxyPass = "http://localhost:8989";
  };

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/sonarr" = {
    device = "/persist/var/lib/sonarr";
    options = [ "bind" ];
  };
}
