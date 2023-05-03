#######################################
# NixOS-specific `nix` configuration. #
#######################################
{ lib, ... }:
{
  imports = [ ./common.nix ];
  nix.settings = {
    # NOTE: Pretty sure this should be the default anyway...
    auto-optimise-store = lib.mkDefault true;
    sandbox = true;
  };
}
