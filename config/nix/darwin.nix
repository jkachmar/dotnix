{ inputs, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
in

mkIf isDarwin {
  # TODO: Should nix-darwin manage the default OS-shell?
  # # Install and configure system shells.
  # environment.shells = [ pkgs.fish ];

  nix = {
    # Darwin sandboxing is still broken.
    # https://github.com/NixOS/nix/issues/2311
    useSandbox = false;

    # TODO: This one seems iffy...
    # # Run the collector automatically every 10 days.
    # options = "--delete-older-than 10d";

    # NOTE: If 'mkForce' isn't applied here, this will merge with the default
    # 'NIX_PATH', appending 'darwin-config' and 'channels' miscellany.
    nixPath = lib.mkForce (
      lib.mapAttrsToList (k: v: "${k}=${v}") {
        darwin = inputs.nix-darwin;
        nixpkgs = pkgs.path;
        unstable = pkgs.unstable.path;
        trunk = pkgs.trunk.path;
      }
    );
  };

  # Auto-upgrade the daemon service.
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
  };

  # TODO: Investigate why this disables home-manager configuration settings.
  #
  # This probably has something to do with hm-session-vars

  # # Install per-user packages.
  # home-manager.useUserPackages = true;
}
