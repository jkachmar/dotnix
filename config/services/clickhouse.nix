{ lib, ... }:

{
  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/clickhouse" = {
    device = "/persist/var/lib/clickhouse";
    options = [ "bind" ];
  };

  services.clickhouse.enable = true;

  networking.firewall.allowedTCPPorts = [
    8123
    8443
  ];
}
