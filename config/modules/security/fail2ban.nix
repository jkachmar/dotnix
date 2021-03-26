{ ... }:
{
  services.fail2ban.enable = true;
  primary-user.persistence.global.fail2ban.directories = [
    "/var/cache/fail2ban"
    "/var/lib/fail2ban"
    "/var/log/fail2ban"
  ];
}
