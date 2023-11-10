{ config, pkgs, ... }:

let
  inherit (config.networking) fqdn;

  dataDir = "/persist/var/lib/metabase";

  listen = {
    ip = "0.0.0.0";
    port = 3939;
  };

in

{
  users = {
    users.metabase = {
      uid = 1100;
      group = "metabase";
      extraGroups = [ "analytics" ];
      isNormalUser = false;
      isSystemUser = true;
    };
    groups.analytics.gid = 1100;
    groups.metabase.gid = 1101;
  };

  systemd.services.metabase = {
    description = "Metabase server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    environment = {
      MB_PLUGINS_DIR = "${dataDir}/plugins";
      MB_DB_FILE = "${dataDir}/metabase.db";
      MB_JETTY_HOST = listen.ip;
      MB_JETTY_PORT = toString listen.port;
    };
    serviceConfig = {
      Type = "simple";
      User = "metabase";
      Group = "metabase";
      StateDirectory = dataDir;
      ExecStart = "${pkgs.metabase}/bin/metabase";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ listen.port ];
  };

  services.nginx.virtualHosts."metabase.${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations."/".proxyPass = "http://localhost:${builtins.toString listen.port}";
  };
}
