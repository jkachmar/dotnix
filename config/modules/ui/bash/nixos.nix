##############################################
# NixOS-specific `bash` shell configuration. #
##############################################
{ ... }:
{
  # OS-agnostic `bash` shell configuration.
  imports = [ ./common.nix ];
  # Persists `.bash_history` on ephemeral systems under a user directory for
  # miscellaneous state.
  primary-user.persistence.home.misc.files = [ ".bash_history" ];
}
