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
    users.nix.configureBuildUsers = true;

    nix.distributedBuilds = true;
    nix.buildMachines = [
      {
        hostName = "10.0.1.150";
        sshUser = "jkachmar";
        sshKey = "/Users/jkachmar/.ssh/id_enigma";
        systems = [ "x86_64-linux" ];
        maxJobs = 2;
      }
    ];

    ###########################################################################
    # Used for backwards compatibility, please read the changelog before
    # changing.
    #
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };
}
