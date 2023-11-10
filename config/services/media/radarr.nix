{ config, ... }:

let
  inherit (config.networking) fqdn;
in
{
  services.radarr = {
    enable = true;
    dataDir = "/persist/var/lib/radarr";
    group = "downloads";
    openFirewall = true;
  };

  # Ensure that radarr waits for the downloads and media directories to be 
  # available.
  systemd.services.radarr = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "mnt-moodyblues-downloads.mount"
      "mnt-moodyblues-media.mount"
    ];
  };

  services.nginx.virtualHosts."radarr.${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations."/".proxyPass = "http://localhost:7878";
  };
}
