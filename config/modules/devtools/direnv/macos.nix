{ lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
in
mkIf isDarwin {
  # NOTE: 'lorri' is a system-level service on macOS, versus the user-level.
  # system configured by 'home-manager' on NixOS.
  services.lorri.enable = true;
}
