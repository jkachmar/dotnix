###############################################################################
# Misc. macOS desktop and user interface settings.
###############################################################################
{ pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      fira-code
    ];
  };

  # macOS system settings.
  system = {
    defaults = {
      # Dock settings.
      dock = {
        autohide = true;
        orientation = "right";
        showhidden = true;
        tilesize = 48;
      };

      NSGlobalDomain = {
        # I don't mind spellcheck, but it's frustrating when it automatically
        # changes things.
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        # Disable natural scrolling; this is fine on the trackpad, but pretty
        # aggravating when using a mouse.
        "com.apple.swipescrolldirection" = false;
      };
      trackpad.Clicking = true;
    };
    keyboard = {
      # Required to remap Caps Lock to Control.
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
