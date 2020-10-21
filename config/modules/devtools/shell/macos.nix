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
  # TODO: Should nix-darwin manage the default OS-shell?
  # # Install and configure system shells.
  # environment.shells = [ pkgs.fish ];

  environment.systemPackages = with pkgs; [ gcoreutils ];

  primary-user.home-manager = {
    home.packages = with pkgs; [
      # Misc. common programs without a better place to go.
      coreutils # lol, macOS (BSD) coreutils are broken somehow
      findutils
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
