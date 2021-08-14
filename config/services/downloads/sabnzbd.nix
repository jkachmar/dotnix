{ ... }:

{
  services.sabnzbd = {
    enable = true;
    group = "downloads";
  };

  # Ensure that sabnzbd waits for the downloads directory to be available.
  systemd.services.sabnzbd = {
    after = [ "network.target" "mnt-moodyblues-downloads.mount" ];
  };

  services.nginx.virtualHosts."sabnzbd.enigma.thempire.dev" = {
    forceSSL = true;
    useACMEHost = "thempire.dev";
    locations."/".proxyPass = "http://localhost:8080";
  };

  # TODO: Factor this out, since other downloads services depend on this group.
  #
  # Create the group for downloads.
  users.groups.downloads.gid = 1010; 

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/sabnzbd" = {
    device = "/persist/var/lib/sabnzbd";
    options = [ "bind" ];
  };
}
