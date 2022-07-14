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

      # NOTE: Testing out 'Secretive' on macOS.
      #
      # The 'IdentityAgent' string below is an artifact of using 'secretive' &
      # its 'Secret Agent' companion to manage SSH keys in Secure Enclave.
      home-manager.programs.ssh = {
        extraConfig = ''
          IdentityAgent ${secretAgentDataPath}/socket.ssh
        '';

        matchBlocks = {
          "10.0.1.150" = {
            hostname = "10.0.1.150";
            user = "jkachmar";
            identityFile = [
              "${secretAgentPubKeysPath}/ff67f327ddfda7771e3741f7bcdd95ce.pub"
            ];
          };
          "github".identityFile = lib.mkForce [
            "${secretAgentPubKeysPath}/8340b1d3d8b43aa144e30866ab4cfe05.pub"
          ];
        };
      };
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
