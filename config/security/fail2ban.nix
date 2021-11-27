{ ... }:
{
  services.fail2ban.enable = true;

  # Ensure that any relevant stateful files are persisted across reboots.
  # 
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/fail2ban" = {
    device = "/persist/var/lib/fail2ban";
    options = [ "bind" ];
  };
}
