{ config, ... }:

let
  inherit (config.networking) fqdn;
in
{
  services.sonarr = {
    enable = true;
    dataDir = "/persist/var/lib/sonarr";
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
    useACMEHost = fqdn;
    locations."/".proxyPass = "http://localhost:8989";
  };
}
