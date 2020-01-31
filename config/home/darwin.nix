{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home = {
    packages = with pkgs; [
      # Better userland for macOS
      coreutils
      emacsMacport
      findutils
      gawk
      gnugrep
      gnused
    ];
  };

  programs.fish.shellInit = ''
    for p in /run/current-system/sw/bin ~/.nix-profile/bin
      if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
      end
    end
  '';
}
