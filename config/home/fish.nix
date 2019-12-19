{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';
      shellInit = ''
        for p in /run/current-system/sw/bin ~/.nix-profile/bin
          if not contains $p $fish_user_paths
            set -g fish_user_paths $p $fish_user_paths
          end
        end
      '';
    };
  };
}
