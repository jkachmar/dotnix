############################################
# NixOS desktop environment configuration. #
############################################
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    layout = "us";

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

  # KDE's stateful components, which should be persisted across reboots.
  #
  # Since KDE clutters things up quite a bit, all of its state is organized
  # under a dedicated subdirectory within the primary user's normal
  # local persistence directory.
  #
  # TODO: Figure out a better abstraction for this...
  primary-user.persistence.home.kde = {
    directories = [
      ".config/glib-2.0"
      ".config/gtk-3.0"
      ".config/kdeconnect"
      ".config/session"
      ".config/xsettingsd"
      ".local/share/konsole"
    ];
    files = [
      ".config/akregatorrc"
      ".config/baloofilerc"
      ".config/gtkrc"
      ".config/gtkrc-2.0"
      ".config/kactivitymanagerdrc"
      ".config/kactivitymanagerd-statsrc"
      ".config/kateschemarc"
      ".config/kcminputrc"
      ".config/kconf_updaterc"
      ".config/kded5rc"
      ".config/kdeglobals"
      ".config/kglobalshortcutsrc"
      ".config/khotkeysrc"
      ".config/kmixrc"
      ".config/konsolerc"
      ".config/kscreenlockerrc"
      ".config/ksmserverrc"
      ".config/ktimezonedrc"
      ".config/kwinrc"
      ".config/kwinrulesrc"
      ".config/kxkbrc"
      ".config/plasma-localerc"
      ".config/plasmanotifyrc"
      ".config/plasma-org.kde.plasma.desktop-appletsrc"
      ".config/plasmashellrc"
      ".config/powermanagementprofilesrc"
      ".config/spectaclerc"
      # XXX: Looks like KDE will always recreate this...
      # ".config/Trolltech.conf"
    ];
  };
}
