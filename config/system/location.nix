{ lib, ... }:

{
  i18n.defaultLocale = lib.mkDefault "en_us.UTF-8";
  time.timeZone = lib.mkDefault "America/New_York";
}