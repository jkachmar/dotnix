###########################################################################
# macOS-specific user input (e.g. keyboard/mouse/trackpad) configuration. #
###########################################################################
{ ... }:

{
  system.defaults = {
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
  };

  system.keyboard = {
    enableKeyMapping = true; # Required to remap Caps Lock to Control.
    remapCapsLockToControl = true;
  };
}
