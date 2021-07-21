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

  environment.systemPackages = (with pkgs.gnome; [
    dconf-editor
    gnome-tweaks
  ]) ++ (with pkgs.gnomeExtensions; [
    appindicator
    bluetooth-quick-connect
    gtile
    sound-output-device-chooser
  ]);
}
