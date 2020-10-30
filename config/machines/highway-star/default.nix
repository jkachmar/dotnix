{ lib, ... }:
let
  sources = import ../../../nix/sources.nix;

  # NOTE: Replicated (approximately) from flake config for the time being...
  overlays = {
    # Inject 'unstable' into the overridden package set, so that the following
    # overlays  may access them (along with any system configs that wish to do
    # so).
    pkgSets = final: prev: {
      unstable = import sources.unstable { };
    };

    overriddenPkgs = import ../../../overlays/overridden_pkgs.nix;
    pinnedPkgs = import ../../../overlays/pinned_pkgs.nix;
    customPkgs = import ../../../overlays/custom_pkgs.nix;
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
    inherit (sources) darwin-stable nix-darwin unstable;
    self.overlays = overlays;
  };

  primary-user.email = "joseph.kachmar@well.co";
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
      # TODO: Make a generalized emacs module under 'config/modules/devtools'
      # TODO: Extract doom config into this repo and use an out-of-store symlink
      emacsMacport
    ];
  };

  # This machine _must_ be run in single-user mode, so we cannot take advantage
  # of the Nix daemon.
  services.nix-daemon = lib.mkForce {
    enable = false;
    enableSocketListener = false;
  };
}
