#######################################
# NixOS-specific `nix` configuration. #
#######################################
{ lib, ... }:
{
  # OS-agnostic `nix` configuration.
  imports = [ ./common.nix ];
  nix = {
    # NOTE: Pretty sure this should be the default anyway...
    autoOptimiseStore = lib.mkDefault true;

    useSandbox = true;
    # TODO: Figure out what automatic garbage collection settings work best.
    # gc = {
    #   automatic = true;
    #   dates = daily;
    #   options = "--delete-older-than 10d";
    # };
  };
}
