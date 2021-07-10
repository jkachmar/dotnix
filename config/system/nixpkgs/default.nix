########################################
# OS-agnostic `nixpkgs` configuration. #
########################################
{ config, inputs, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;
  macosDotfiles = "$HOME/.config/dotfiles";
  darwinCfg = "${macosDotfiles}/hosts/${config.networking.hostName}";
in
{
  nix = {
    nixPath = lib.mkForce ([
      "unstable=${inputs.unstable}"
    ] ++ lib.optionals isDarwin [
      "nixpkgs=${inputs.macosPkgs}"
      "darwin=${inputs.darwin}"
      "darwin-config=${lib.traceVal darwinCfg}"
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
    # NOTE: For some reason if this enabled on macOS it totally breaks
    # home-manager's package installation.
    useUserPackages = isLinux;
  };
  primary-user.home-manager.xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
}
