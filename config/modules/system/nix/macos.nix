#######################################
# macOS-specific `nix` configuration. #
#######################################
{ ... }:
{
  # OS-agnostic `nix` configuration.
  imports = [ ./common.nix ];
}
