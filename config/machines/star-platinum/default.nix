#########################
# Machine Configuration #
#########################
{ config, inputs, lib, pkgs, unstable, ... }:

{
  imports = [
    ../../profiles/nixos/desktop.nix
    ./hardware.nix
  ];

  config = {
    ###################################
    # Machine & Primary User Identity #
    ###################################
    networking.hostName = "star-platinum";
    networking.hostId = "68210a0b"; # Required for ZFS.
    environment.etc."machine-id".text = "0aaab60e7c4a49d49c953e4972dbe443";

    # TODO: All deploys should use immutable users where possible, so this
    # should be a part of the base nixos config module.
    users.mutableUsers = false;

    # FIXME: Change this to a different password from the `primary-user`.
    users.users.root.initialHashedPassword =
      "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";

    # System config for the primary user.
    primary-user = {
      home-manager.imports = [ "${inputs.impermanence}/home-manager.nix" ];

      # TODO: Move this out, it's just here to test something.
      home-manager.home.sessionVariables.LESS = "--mouse";

      name = "jkachmar";
      git.user.name = config.primary-user.name;
      git.user.email = "git@jkachmar.com";
      # FIXME: Change this to a different password from the root user.
      initialHashedPassword =
        "$6$8IEIbo7aITp8$5A68B049UisI4S5HTMgsCZ24aZf4QsoC.cOpOLZSrpzostOCOqosm2veCq0iMQy9sWb5GP5BC.N3EcjI6Vphh0";
      # Declare base directories under which the primary account holder's
      # persistent content shall be stored.
      #
      # TODO: Should there only be one base directory, with the "local" state
      # automatically placed under `${config.primary-user.name}/home`?
      persistence.base-directories = {
        global = "/state";
        home = "/state/jkachmar/home";
      };
      # System-level persistent state.
      # 
      # TODO: Consider factoring these out... somehwere else?
      persistence.global = {
        # Global `journald` (et al.) logs.
        logs.directories = [ "/var/log" ];
        # NixOS system configuration (et al.) files.
        #
        # NOTE: Ideally this could be declaratively set to one of the stateful
        # directories, but it seems that NixOS works best if these files are
        # present at `/etc/nixos`.
        nixos.directories = [ "/etc/nixos" ];
        # Miscellaneous stateful configuration files and directories.
        #
        # This is often a staging ground for things before they're broken out
        # into dedicated modules or stateful directory trees.
        misc = {
          directories = [
            "/var/lib/docker"
            "/etc/NetworkManager"
          ];
          files = [ "/etc/docker/key.json" ];
        };
      };
      # Miscellaneous user-level persistent state.
      persistence.home.misc.directories = [
        "code" # Misc. software projects.
        ".ssh" # SSH keys and configurations.

        # TODO: Move this out to a dedicated Haskell development module.
        ".cabal" # `cabal-install` artifacts.

        # TODO: Move this out to a more generic module.
        ".config/obsidian" # Obsidian notes configuration.
      ];
    };

    #########################
    # Networking & Firewall #
    #########################

    networking = {
      firewall.enable = true;
      interfaces = {
        enp4s0.useDHCP = true;
        wlp5s0.useDHCP = true;
      };
      networkmanager.enable = true;
      # TODO: Work around some issues w/ stateless WPA supplicant.
      # wireless = {
      #   enable = false;
      #   userControlled.enable = true;
      #   networks = {
      #     "king-crimson".pskRaw =
      #       "f30641e23c4da508d59c1d258bd2a39b33e93d473358b65f699b64387d431d86";
      #   };
      # };
    };

    ##############
    # Miscellany #
    ##############

    # Play nice with Windows hardware clock settings.
    time.hardwareClockInLocalTime = true;
    # System time zone; my desktop isn't moving any time soon.
    time.timeZone = "America/New_York";

    ###################
    # NixOS Esoterica #
    ###################

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken.
    #
    # It‘s perfectly fine and recommended to leave this value at the release
    # version of the first install of this system.
    #
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "20.09"; # Did you read the comment?
  };
}
