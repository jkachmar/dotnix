{ config, ... }:

let
  inherit (config.networking) domain fqdn;
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
      "${fqdn}" = {
        inherit email;
        credentialsFile = "/secrets/cloudflare/acme.env";
        dnsProvider = "cloudflare";
        extraDomainNames = [ "*.${fqdn}" ];

        # Use Cloudflare's DNS resolver rather than the system-provided one to
        # ensure that everything propagates as quickly as possible.
        extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
      };
    };
  };
}
