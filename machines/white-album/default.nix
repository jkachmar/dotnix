{ stablePkgs
, overlays
, home
, nix-darwin
, ...
}:
let
  machine = { ... }: {
    imports = [
      ./hardware.nix
      (import ../../modules/nix/primary-user)
    ];

    # Inject sources that are used by other configuration modules.
    _module.args.nix-darwin = nix-darwin;
    _module.args.overlays = overlays;

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
    # Used for backwards compatibility, consult the changelog before changing.
    system.stateVersion = 4;
  };

  modules = [
    home.darwinModules.home-manager
    machine
    ../../config/nix/default.nix
    ../../modules/system/darwin.nix
    ../../modules/desktop
    ../../modules/development
  ];

  darwin = import nix-darwin {
    configuration = { ... }: { imports = modules; };
    nixpkgs = stablePkgs;
    system = "x86_64-darwin";
  };
in

darwin.system
