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
  };
}
