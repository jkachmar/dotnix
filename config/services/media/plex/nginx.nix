##############################################
# Nginx Reverse Proxy Configuration for Plex #
##############################################
{ config, ... }:

let
  inherit (config.networking) fqdn;
in
{
  services.nginx.virtualHosts."plex.${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    http2 = true;
    locations."/" = {
      proxyPass = "https://localhost:32400";
      proxyWebsockets = true;
    };

    extraConfig = ''
      # Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
      send_timeout 100m;

      # Forward real ip and host to Plex
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $server_addr;
      proxy_set_header Referer $server_addr;
      proxy_set_header Origin $server_addr;

      # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
      gzip on;
      gzip_vary on;
      gzip_min_length 1000;
      gzip_proxied any;
      gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
      gzip_disable "MSIE [1-6]\.";

      # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
      # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
      client_max_body_size 100M;

      # Plex headers
      proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
      proxy_set_header X-Plex-Device $http_x_plex_device;
      proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
      proxy_set_header X-Plex-Platform $http_x_plex_platform;
      proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
      proxy_set_header X-Plex-Product $http_x_plex_product;
      proxy_set_header X-Plex-Token $http_x_plex_token;
      proxy_set_header X-Plex-Version $http_x_plex_version;
      proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
      proxy_set_header X-Plex-Provides $http_x_plex_provides;
      proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
      proxy_set_header X-Plex-Model $http_x_plex_model;

      # Buffering off send to the client as soon as the data is received from Plex.
      proxy_redirect off;
      proxy_buffering off;
    '';
  };
}
