###################################################
# NixOS-specific `dnscrypt-proxy2` configuration. #
###################################################
{ lib, ... }:

{
  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: `/var/lib/private` is due to the upstream `systemd` unit definition
  # using `DynamicUser = true`.
  environment.persistence."/state/dns".directories = [
    "/var/lib/private/dnscrypt-proxy2"
  ];

  # TODO: Document why this is necessary; should be something on the NixOS
  # wiki to link to.
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = lib.mkForce "dnscrypt-proxy2";
  };

  services.dnscrypt-proxy2.enable = true;

  # See the upstream TOML configuration example for a documented list of
  # available settings:
  #
  # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
  services.dnscrypt-proxy2.settings = {
    # XXX: AFAICT there's no way to tell `dnscrypt-proxy2` to prioritize one
    # server over the other.
    #
    # Ideally this could specify servers to try in order of priority so
    # `cloudflare` could be set as a fallback even though I prefer Quad9.
    server_names = [
      "quad9-doh-ip4-nofilter-pri"
    ];

    # TODO: Set these up after updating nixpkgs to something that provides
    # the latest version of `dnscrypt-proxy`.
    fallback_resolvers = [ "9.9.9.9:53" "1.1.1.1:53" ];
    ignore_system_dns = true;

    # This is the address that the PiHole listens on for its DNS resolution;
    # for now it just uses the default Podman gateway IP, but it would be nice
    # to explicitly specify this as a CNI network setting.
    #
    # TODO: Look into switching to the PiHole Nix module whenever
    # https://github.com/NixOS/nixpkgs/pull/108055 whenever is finished/merged.
    #
    # TODO: Set this somewhere else in the `config`
    listen_addresses = [ "10.88.0.1:5053" ];

    # Prefer DNS-Over-HTTPS and require DNSSEC verification for the proxies.
    doh_servers = true;
    dnscrypt_servers = false;
    require_dnssec = true;

    # Only allow servers without filtering (PiHole takes care of this) or
    # logging.
    #
    # NOTE: This is more useful for configurations with multiple server names;
    # in my case, since Quad9 is the only one selected, if they add filtering
    # or logging DNS resolution will simply break.
    require_nofilter = true;
    require_nolog = true;

    # TODO: Finish figuring out IPv6 networking...
    ipv6_servers = false;

    # Source list for the information associated with entries in the
    # `server_names` config block above.
    sources = {
      # Quad9 DNS resolvers.
      quad9-resolvers = {
        urls = [ "https://www.quad9.net/quad9-resolvers.md" ];
        cache_file = "/var/lib/dnscrypt-proxy2/quad9-resolvers.md";
        minisign_key = "RWQBphd2+f6eiAqBsvDZEBXBGHQBJfeG6G+wJPPKxCZMoEQYpmoysKUN";
        refresh_delay = 72;
        prefix = "quad9-";
      };

      # Public DNS resolvers.
      public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          "https://ipv6.download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          "https://download.dnscrypt.net/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
        prefix = "";
      };

      # Anonymized DNS relays.
      relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
          "https://ipv6.download.dnscrypt.info/resolvers-list/v3/relays.md"
          "https://download.dnscrypt.net/resolvers-list/v3/relays.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
        prefix = "";
      };
    };
  };
}
