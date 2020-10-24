{ lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isLinux;
in
mkIf isLinux {
  primary-user.home-manager = {
    services.lorri.enable = true;
  };
}
