########################################
# OS-agnostic `nixpkgs` configuration. #
########################################
{ inputs, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.targetPlatform) isLinux;
in
{
  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "unstable=${inputs.unstable}"
    ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.unstable;
    };
  };

  nixpkgs = {
    config = import ./config.nix;
    # TODO: Stick construct overlays in `flake.nix` and stick them in the
    # module args (or something).
    overlays = [ ];
  };

  # TODO: Document why both of these settings are being enabled.
  #
  # The short answer is that someone recommended it when using home-manager
  # and Flakes, but this deserves a more rigorous explanation.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  primary-user.home-manager.xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
}
