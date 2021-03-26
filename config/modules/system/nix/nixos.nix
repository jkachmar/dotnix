#######################################
# NixOS-specific `nix` configuration. #
#######################################
{ ... }:
{
  # OS-agnostic `nix` configuration.
  imports = [ ./common.nix ];
  nix = {
    useSandbox = true;
    # TODO: Figure out what automatic garbage collection settings work best.
    # gc = {
    #   automatic = true;
    #   dates = daily;
    #   options = "--delete-older-than 10d";
    # };
  };
}
