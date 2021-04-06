########################################################################
# Miscellaneous macOS-specific desktop configuration and applications. #
########################################################################
{ pkgs, ... }:

{
  homebrew = {
    brews = [ ];
    casks = [
      "amethyst" # Tiling window manager.
      "discord"
      "iterm2"
      "itsycal" # Titlebar calendar.
      "sensiblesidebuttons"
    ];
    # Mac App Store applications.
    #
    # NOTE: Use the `mas` CLI to search for the number associated with a given
    # application name.
    #
    # e.g. `mas search 1Password`
    masApps = {
      "1Password 7 - Password Manager" = 1333542190;
      "Slack" = 803453959;
    };
  };
}
