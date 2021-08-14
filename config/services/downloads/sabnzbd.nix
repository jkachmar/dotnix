{ ... }:

{
  services.sabnzbd = {
    enable = true;
    group = "downloads";
  };

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/sabnzbd" = {
    device = "/persist/var/lib/sabnzbd";
    options = [ "bind" ];
  };
}
