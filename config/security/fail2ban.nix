{ ... }:
{
  services.fail2ban.enable = true;
  systemd.tmpfiles.rules = [
    "L /var/lib/fail2ban - - - - /persist/var/lib/fail2ban"
  ];
}
