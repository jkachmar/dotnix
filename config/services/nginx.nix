{ config, ... }:

let
  inherit (config.networking) domain;
  inherit (config.primary-user) email;
in
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 80 443 ];
  };

  # Nginx needs to be able to read the certificates
  users.users.nginx.extraGroups = [ "acme" ];

  security.acme.defaults = { inherit email; };

  security.acme = {
    acceptTerms = true;
    # Do not install self-signed certs initially; this appears to be
    # incompatible with nginx OCSP stapling & can create a race condition upon
    # reboot.
    preliminarySelfsigned = false;

    certs = {
      "thempire.dev" = {
        inherit email;
        credentialsFile = "/secrets/cloudflare/acme.env";
        dnsProvider = "cloudflare";
        extraDomainNames = [
          "*.thempire.dev"
          "*.enigma.thempire.dev"
          "*.moody-blues.thempire.dev"
        ];

        # Use Cloudflare's DNS resolver rather than the system-provided one to
        # ensure that everything propagates as quickly as possible.
        extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
      };
    };
  };

  services.nginx.virtualHosts = {
    # NOTE: Ensure this server is trusted by adding its IP to the NAS via
    # 'Control Panel' -> 'Security' -> 'Trusted Proxies' in the DSM webapp.
    "moody-blues.${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations."/" = {
        proxyPass = "https://192.168.1.155:5001";
        extraConfig = ''
          # Causes issues w/ uploading very large files via Synology web UI.
          client_max_body_size 0;
          proxy_request_buffering off;
        '';
      };
    };

    "webdav.moody-blues.${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations."/".proxyPass = "https://192.168.1.155:5006";
    };
  };
}
