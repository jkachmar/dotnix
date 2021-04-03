########################################################################
# Miscellaneous macOS-specific desktop configuration and applications. #
########################################################################
{ pkgs, ... }:

{
  homebrew = {
    brews = [ "mas" ];
    casks = [
      "amethyst" # Tiling window manager.
      "discord"
      "itsycal" # Titlebar calendar.
      "sensiblesidebuttons"
    ];
  };
}
