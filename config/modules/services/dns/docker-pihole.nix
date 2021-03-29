#####################################################
# NixOS-specific, Docker-based PiHole configuration #
#####################################################
{ config, ... }:

{
  # Use Docker to run OCI containers.
  #
  # TODO: Factor OCI container backend configuration out to a more generic
  # module if/when more OCI-based services are added.
  #
  # TODO: Try `podman` again at some point; it was difficult to figure out
  # stateful persistence the first time, whereas Docker "just worked"...
  virtualisation.oci-containers.backend = "docker";

  # TODO: Factor docker state persistence out to a more generic module if/when
  # more OCI-based services are added.
  environment.persistence."/state/docker".directories = [
    "/var/lib/docker"
  ];

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # TODO: Factor docker state persistence out to a more generic module if/when
  # more Docker-based services are added.
  environment.persistence."/state/dns".directories = [
    "/etc/pihole"
    "/etc/dnsmasq.d"
  ];

  # OCI-based PiHole service.
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      # TODO: Remap these at some point; this is for a general-purpose server
      # and it's dumb that PiHole hijacks these ports.
      "80:80"
      "443:443"
    ];
    # TODO: Look into factoring out the persistent state config so it can
    # reused in this section as well (to avoid having to manually reconcile
    # these two).
    volumes = [
      "/etc/pihole/:/etc/pihole/"
      "/etc/dnsmasq.d/:/etc/dnsmasq.d/"
    ];
    # TODO: Set `dnscrypt-proxy` resolver using an environment variable here.
    environment = {
      TZ = config.time.timeZone;
      # TODO: Change this to something secure, obviously.
      #
      # For now it's local-only and I don't let anyone on this network if I
      # don't trust them anyway, but just on principle this is dumb.
      WEBPASSWORD = "hunter2";
    };
    extraOptions = [
      "--dns=127.0.0.1"
      "--dns=1.1.1.1"
    ];
    workdir = "/etc/pihole";
    autoStart = true;
  };

  systemd.services.docker-pihole = {
    # XXX: What is _actually_ the right order-of-operations here?
    after = [ "network.target" ];
    # TODO: Document why this is necessary.
    #
    # There should be a NixOS issue explaining how 20.09 introduced a change
    # that breaks forwarding logs from the Docker daemon to `journald`
    # without this override.
    serviceConfig = {
      StandardOutput = lib.mkForce "journal";
      StandardError = lib.mkForce "journal";
    };
  };
}
