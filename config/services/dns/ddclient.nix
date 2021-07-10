# 'ddclient' dynamic DNS configuration.
{ ... }:

{
  services.ddclient = {
    enable = true;
    configFile = "/secrets/ddclient/config";
  };
}
