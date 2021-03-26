##########################################
# NixOS-specific `direnv` configuration. #
##########################################
{ ... }:
{
  # OS-agnostic `direnv` configuration.
  imports = [ ./common.nix ];
  primary-user.persistence.home.misc.directories = [
    ".local/share/direnv/allow"
  ];
}
