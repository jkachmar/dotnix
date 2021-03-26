{ config, ... }:
{
  imports = [
    ./hardware.nix
    ../../profiles/macos.nix
  ];

  config = {
    networking.hostName = "crazy-diamond";

    primary-user = {
      name = "jkachmar";
      git.user.name = config.primary-user.name;
      git.user.email = "me@jkachmar.com";
    };

    # TODO: Abstract this out.
    services.nix-daemon.enable = true;

    ###########################################################################
    # Used for backwards compatibility, please read the changelog before
    # changing.
    #
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };
}
