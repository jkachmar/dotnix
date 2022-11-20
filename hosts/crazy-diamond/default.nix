{ config, lib, ... }:
let
  name = "jkachmar";
  secretAgentDataPath = "/Users/${name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data";
  secretAgentPubKeysPath = "${secretAgentDataPath}/PublicKeys";
in
{
  imports = [
    ./hardware.nix
    ../../profiles/macos.nix
    ../../config/desktop/macos/applications.nix
  ];

  config = {
    networking.hostName = "crazy-diamond";

    primary-user = {
      inherit name;
      git.user.name = config.primary-user.name;
      git.user.email = "git@jkachmar.com";
      user.home = /Users/${name};
    };

    # TODO: Abstract this out.
    services.nix-daemon.enable = true;
    users.nix.configureBuildUsers = true;

    nix.distributedBuilds = true;
    nix.buildMachines = [
      {
        hostName = "192.168.1.150";
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
