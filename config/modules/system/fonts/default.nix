###############################################################################
# System font installation, configuration, and management.
###############################################################################
{ pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      font-awesome_5
      noto-fonts
    ];
  };
}
