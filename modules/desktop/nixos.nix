###############################################################################
# Desktop, sound, and graphics.
###############################################################################

{ lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isLinux;
in

mkIf isLinux {
  ###############################################################################
  # User-level configuration.
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
