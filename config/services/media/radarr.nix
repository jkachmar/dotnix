{ config, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
in
{
  services.radarr = {
    enable = true;
    dataDir = "/persist/downloads/radarr";
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
    useACMEHost = domain;
    locations."/".proxyPass = "http://localhost:7878";
  };
}
