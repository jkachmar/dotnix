{ lib, pkgs, ... }:

let
  inherit (lib) mkForce;
in

{
  imports = [ ./macos.nix ./nixos.nix ];

  primary-user.home-manager = {
    home.packages = with pkgs; mkForce [
      direnv
      nix-direnv
    ];

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
  };
}
