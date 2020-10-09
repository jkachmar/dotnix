{ stablePkgs
, _unstablePkgs
, _trunkPkgs
, overlays
, home
, nix-darwin
, ...
}:
let
  caches = import ../../config/nix/caches.nix;
  home-manager = home.darwinModules.home-manager;
  primary-user = import ../../modules/nix/primary-user;

  global = { _pkgs, ... }: {
    imports = [
      ./hardware.nix
      primary-user
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
  };

  nix = { _pkgs, ... }:
    let
      nixpkgs = {
        inherit overlays;
        config.allowUnfree = true;
      };
    in
      {
        inherit nixpkgs;
        nix = {
          binaryCaches = caches.substituters;
          binaryCachePublicKeys = caches.keys;
          extraOptions = ''
            experimental-features = nix-command flakes ca-references
          '';
          package = pkgs.nixFlakes;
        };

        primary-user.home-manager = {
          inherit nixpkgs;
          xdg = {
            enable = true;
            # configFile."nixpkgs/config.nix".source = nixpkgsConfig;
            configFile."nix/nix.conf".text = ''
              experimental-features = nix-command flakes
              substituters = ${toString caches.substituters}
              trusted-public-keys = ${toString caches.keys}
            '';
          };
        };
      };

  modules = [
    home-manager
    global
    nix
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
