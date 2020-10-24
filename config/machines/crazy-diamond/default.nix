{ ... }:
let
  sources = import ../../../nix/sources.nix;

  # NOTE: Replicated from flake config for the time being...
  overlays = {
    # Inject 'unstable' and 'trunk' into the overridden package set, so that
    # the following overlays may access them (along with any system configs
    # that wish to do so).
    pkg-sets = final: prev: {
      unstable = import sources.unstable { inherit (final) system; };
      trunk = import sources.trunk { inherit (final) system; };
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

  # NOTE: Replicated from flake config for the time being...
  _module.args.inputs = {
    inherit (sources) darwin-stable nix-darwin unstable trunk;
    self.overlays = overlays;
  };

  primary-user.email = "me@jkachmar.com";
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = "jkachmar";
  networking.hostName = "crazy-diamond";

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
