##################################################
# NixOS GNOME desktop environment configuration. #
##################################################
{ pkgs, ... }:
{
  services.xserver = {
    # Use GNOME as the desktop environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
