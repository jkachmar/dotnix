{ lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;

  gcoreutils = pkgs.coreutils.override {
    singleBinary = false;
    withPrefix = true;
  };
in

mkIf isDarwin {
  ###############################################################################
  # System-level configuration.
  environment.systemPackages = with pkgs; [ gcoreutils ];

  programs = {
    bash.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  ###############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    home.packages = with pkgs; [
      coreutils # lol, macOS (BSD) coreutils are broken somehow
      emacsMacport
      findutils
      lorri
    ];

    # Fixes a bug where fish shell doesn't properly set up the nix path on macOS.
    programs.fish.shellInit = ''
      for p in /run/current-system/sw/bin ~/.nix-profile/bin
        if not contains $p $fish_user_paths
          set -g fish_user_paths $p $fish_user_paths
        end
      end
    '';
  };
}
