########################################
# OS-agnostic `nixpkgs` configuration. #
########################################
{ config, inputs, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;
in
{
  nix = {
    nixPath = lib.mkForce ([
      "unstable=${inputs.unstable}"
    ] ++ lib.optionals isDarwin [
      "nixpkgs=${inputs.macosPkgs}"
      "darwin=${inputs.darwin}"
      (lib.traceVal "darwin-config=$HOME/.config/dotfiles/config/machines/${config.networking.hostName}")
    ] ++ lib.optionals isLinux [
      "nixpkgs=${inputs.nixosPkgs}"
    ]);

    registry = {
      nixpkgs.flake = if isDarwin then inputs.macosPkgs else inputs.nixosPkgs;
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
