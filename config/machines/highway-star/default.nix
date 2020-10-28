{ ... }:
let
  sources = import ../../../nix/sources.nix;

  # NOTE: Replicated (approximately) from flake config for the time being...
  overlays = {
    # Inject 'unstable' and 'trunk' into the overridden package set, so that
    # the following overlays may access them (along with any system configs
    # that wish to do so).
    pkg-sets = final: prev: {
      unstable = import sources.unstable { };
      trunk = import sources.trunk { };
    };

    overridden_pkgs = import ../../../overlays/overridden_pkgs.nix;
    pinned_pkgs = import ../../../overlays/pinned_pkgs.nix;
    custom_pkgs = import ../../../overlays/custom_pkgs.nix;
  };
in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
    ./hardware.nix
    ../../profiles/macos
  ];

  # NOTE: Replicated (approximately) from flake config for the time being...
  _module.args.inputs = {
    inherit (sources) darwin-stable nix-darwin unstable trunk;
    self.overlays = overlays;
  };

  primary-user.email = "joseph.kachmar@well.com";
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = "jkachmar";
  networking.hostName = "highway-star";

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  ###############################################################################
  # Machine-specific configuration.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [
      awscli
      customNodePackages.aws-azure-login
    ];
  };

  # This machine _must_ be run in single-user mode, so we cannot take advantage
  # of the Nix daemon.
  services.nix-daemon.enable = lib.mkForce {
    enable = false;
    enableSocketListener = false;
  };
}
