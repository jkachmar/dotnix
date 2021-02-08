###############################################################################
# macOS-specitic Nix system configuration.
###############################################################################
{ inputs, lib, pkgs, ... }:
let
  inherit (lib) mkForce mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
in
mkIf isDarwin {
  nix = {
    # Darwin sandboxing is still broken.
    # https://github.com/NixOS/nix/issues/2311
    useSandbox = false;

    # TODO: This one seems iffy...
    # # Run the collector automatically every 10 days.
    # options = "--delete-older-than 10d";

    # NOTE: If 'mkForce' isn't applied here, this will merge with the default
    # 'NIX_PATH', appending 'darwin-config' and 'channels' miscellany.
    nixPath = mkForce (
      lib.mapAttrsToList (k: v: "${k}=${v}") {
        inherit (inputs) darwin unstable;
        darwin-config = inputs.config-path;
        nixpkgs = pkgs.path;
      }
    );
  };

  # Auto-upgrade the daemon service.
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
  };

  # Use the global 'nixpkgs' set for home-manager;
  home-manager.useGlobalPkgs = true;
}
