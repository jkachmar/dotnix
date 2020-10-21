{ ... }:

{
  imports = [
    ./hardware.nix
    ../../profiles/macos
  ];

  networking.hostName = "white-album";
  time.timeZone = "America/New_York";

  primary-user = {
    email = "me@jkachmar.com";
    fullname = "Joe Kachmar";
    username = "jkachmar";
    # Necessary for flakes support.
    home-manager.config.home.stateVersion = "20.09";
  };

  ###########################################################################
  # nix-darwin configuration.

  # Everything is being managed with flakes, so <darwin> and <darwin-config>
  # won't be set up as-expected.
  system.checks.verifyNixPath = false;

  # Used for backwards compatibility, consult the changelog before changing.
  system.stateVersion = 4;
}
