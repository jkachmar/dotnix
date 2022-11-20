{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
  listen = {
    address = "0.0.0.0";
    port = 5050;
  };
in
{
  services.libreddit = {
    enable = true;
    inherit (listen) address port;
    redirect = true;
    openFirewall = false;
  };

  services.nginx.virtualHosts."reddit.${fqdn}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://${listen.address}:${builtins.toString listen.port}";
      proxyWebsockets = true;
    };
  };
}
