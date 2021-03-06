#####################################
# Misc. NixOS desktop applications. #
#####################################
{ pkgs, unstable, ... }:
let
  # # TODO: Move this out to an overlay (i.e. figure out how overlays are going
  # # to work with a Flakes-based configuration).
  # updated-signal-desktop = pkgs.signal-desktop.overrideAttrs (_oldAttrs: rec {
  #   version = "1.40.0";
  #   src = pkgs.fetchurl {
  #     url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  #     sha256 = "1xd38a9mi23c4r873k37rzip68hfk3a4bk9j4j24v2kb3yvixrpp";
  #   };
  # });
  updated-signal-desktop = pkgs.signal-desktop.override {
    spellcheckerLanguage = "en_US";
  };
in
{
  primary-user = {
    home-manager.home.packages = with pkgs; [
      discord
      emacs # TODO: Move this out to a dedicated Emacs module.
      firefox
      slack # NOTE: 21.05 = v4.15.0; unstable = v4.16.0
      xclip # Clipboard selection a la `cat foo | xclip -selection clipboard`
      zoom-us

      # Custom/overridden packages.
      updated-signal-desktop
    ];

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
