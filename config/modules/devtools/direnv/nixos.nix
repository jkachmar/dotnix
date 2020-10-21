{ lib, pkgs, ... }:

let
  inherit (lib) mkForce mkIf;
  inherit (pkgs.stdenv.targetPlatform) isLinux;
in

mkIf isLinux {
  primary-user.home-manager = {
    home.packages = with pkgs; mkForce [ lorri ];
    services.lorri.enable = true;
  };
}
