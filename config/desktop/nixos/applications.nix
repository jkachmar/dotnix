#####################################
# Misc. NixOS desktop applications. #
#####################################
{ pkgs, unstable, ... }:
{
  # TODO: lol this is gonna probably need some customization.
  # TODO: Figure out overlays and see how difficult it is to pull in an
  # updated copy of the steam config?
  # TODO: Move this & the controller config out into a gaming module.
  # XXX: lmao what the URL is 404-ing???
  # programs.steam.enable = true;
  hardware.xpadneo.enable = true;

  primary-user = {
    home-manager.home.packages = (with pkgs; [
      emacs # TODO: Move this out to a dedicated Emacs module.
      firefox
      slack
      xclip # Clipboard selection a la `cat foo | xclip -selection clipboard`
      zoom-us
    ]) ++ (with unstable; [
      # NOTE: Discord sometimes refuses to open without the latest version.
      #
      # cf. https://nixos.wiki/wiki/Discord#Discord_wants_latest_version
      discord
      signal-desktop
    ]);

    # XXX: The `mimeApps` stuff is a little weird, see the following issues for
    # more information:
    #
    # https://github.com/nix-community/home-manager/issues/1220
    # https://github.com/nix-community/home-manager/issues/1213
    #
    # Basically, other applications may override `mimeapps.list` so
    # `home-manager` should always override whatever file exists on-disk.
    home-manager.xdg.configFile."mimeapps.list".force = true;
    home-manager.xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/sgnl" = "signal-desktop.desktop";
        "x-scheme-handler/zoommtg" = "zoom.desktop";
      };
    };
  };
}
