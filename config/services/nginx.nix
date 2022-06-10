{ config, ... }:

let
  email = config.primary-user.email;
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

    certs = {
      "thempire.dev" = {
        inherit email;
        credentialsFile = "/secrets/cloudflare/acme.env";
        dnsProvider = "cloudflare";
        extraDomainNames = [
          "*.thempire.dev"
          "*.enigma.thempire.dev"
        ];

        # Use Cloudflare's DNS resolver rather than the system-provided one to
        # ensure that everything propagates as quickly as possible.
        extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
      };
    };
  };
}
