##############################################
# NixOS K desktop environment configuration. #
##############################################
{ pkgs, ... }:
{
  services.xserver = {
    # Use KDE as the desktop environment.
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  primary-user.home-manager.home.packages = with pkgs.plasma5Packages.kdeApplications; [
    ark
    kate
    kcalc
    pkgs.kdeconnect
    pkgs.kdeplasma-addons
    spectacle
  ];

  # TODO: Abstract this out to the `primary-user` configuration.
  security.pam.services.jkachmar.enableKwallet = true;
}
