########################################################################
# macOS configuration options for the system's primary account holder. #
########################################################################
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkIf;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
  cfg = config.primary-user;
in
{
  # OS-agnostic options/aliases.
  imports = [ ./common.nix ];
  # Define macOS-specific `primary-user` configuration.
  config = mkIf (cfg.name != null) {
    primary-user.uid = mkDefault 1000;
    users.users.${cfg.name}.name = cfg.name;
    nix = {
      # Run the garbage collector as the primary-user.
      gc.user = cfg.name;
      # TODO: Should this use `lib.mkMerge` and _only_ specify the primary user
      # as an allowed and/or trusted user?
      allowedUsers = [ "root" cfg.name "@admin" "@wheel" ];
      trustedUsers = [ "root" cfg.name "@admin" "@wheel" ];
    };
  };
}
