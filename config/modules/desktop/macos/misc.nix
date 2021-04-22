########################################################################
# Miscellaneous macOS-specific desktop configuration and applications. #
########################################################################
{ pkgs, ... }:

{
  homebrew = {
    brews = [ ];
    casks = [
      "amethyst" # Tiling window manager.
      "discord" # Nerd chat.
      "iterm2" # A terminal emulator with font rendering & tmux support.
      "itsycal" # Titlebar calendar.
      "sensiblesidebuttons"
      "virtualbox" # Virtualization (duh).
      "virtualbox-extension-pack" # Virtualization helpers.
      # XXX: For now, the Safari connector is only available in the Zotero beta
      # (which is not available on homebrew).
      # "zotero" # Research paper catalog & organizer.
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
