###############################################################################
# Various NixOS desktop applications.
###############################################################################
{ pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = with pkgs; with kdeApplications; [
      anki
      discord
      firefox
      irccloud
      signal-desktop
      slack
      spotify

      # KDE/Plasma packages
      ark
      kcalc
      kdeconnect
      kdeplasma-addons
      spectacle
    ];
  };
}
