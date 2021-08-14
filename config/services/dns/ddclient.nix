# 'ddclient' dynamic DNS configuration.
{ ... }:

{
  services.ddclient = {
    enable = true;
    configFile = "/secrets/ddclient/config";
  };

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: '/var/lib/private' is due to the upstream 'systemd' unit definition
  # using 'DynamicUser = true'.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/private/ddclient" = {
    device = "/persist/var/lib/ddclient";
    options = [ "bind" ];
  };
}
