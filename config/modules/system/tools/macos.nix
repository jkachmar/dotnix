#######################################
# macOS-specific shell configuration. #
#######################################
{ lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;

  gcoreutils = pkgs.coreutils.override {
    singleBinary = false;
    withPrefix = true;
  };
in
{
  # OS-agnostic shell configuration.
  imports = [ ./common.nix ];

  environment.systemPackages = with pkgs; [ gcoreutils ];
  primary-user.home-manager = {
    home.packages = with pkgs; [
      # Misc. common programs without a better place to go.
      coreutils # lol, macOS (BSD) coreutils are broken somehow
    ];
  };
}
