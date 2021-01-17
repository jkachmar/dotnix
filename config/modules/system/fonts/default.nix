###############################################################################
# System font installation, configuration, and management.
###############################################################################
{ pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      font-awesome_5
      hack-font
      ibm-plex
      jetbrains-mono
      overpass
    ];
  };
}
