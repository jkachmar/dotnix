##############################################
# NixOS-specific `fish` shell configuration. #
##############################################
{ pkgs, ... }:
{
  # OS-agnostic `fish` shell configuration.
  imports = [ ./common.nix ];
  # Required by `fish` to display help text for functions.
  primary-user = {
    home-manager.home.packages = [ pkgs.groff ];
    # NOTE: Fish doesn't support just persisting the `fish_history` file.
    #
    # `history clear` (and other destructive commands) will destroy the
    # symlink.
    persistence.home.misc.directories = [
      ".config/fish"
      ".local/share/fish"
    ];
  };
}
