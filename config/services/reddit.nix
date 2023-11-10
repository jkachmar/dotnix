{ config, pkgs, ... }:

let
  inherit (config.networking) fqdn;
  listen = {
    address = "0.0.0.0";
    port = 5050;
  };
in
{
  services.libreddit = {
    enable = true;
    inherit (listen) address port;
    # redirect = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."reddit.${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations."/" = {
      proxyPass = "http://${listen.address}:${builtins.toString listen.port}";
      proxyWebsockets = true;
    };
  };
}
