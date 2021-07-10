##############################################
# macOS-specific `fish` shell configuration. #
##############################################
{ ... }:
{
  # OS-agnostic `fish` shell configuration.
  imports = [ ./common.nix ];

  # Required on macOS so that `fish` picks up the updated `NIX_PATH`.
  programs.fish.enable = true;

  # Fixes a bug where fish shell doesn't properly set up the nix path on macOS.
  primary-user.home-manager.programs.fish.shellInit = ''
    for p in /run/current-system/sw/bin ~/.nix-profile/bin
      if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
      end
    end
  '';
}
