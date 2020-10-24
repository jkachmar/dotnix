{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
  cfg = config.primary-user;
in
{
  config = lib.mkIf (cfg.username != null && isDarwin) {
    primary-user = {
      uid = lib.mkDefault 1000;
    };
    users.users.${cfg.username}.name = cfg.username;
    nix = {
      # Run the garbage collector as the primary-user.
      gc.user = cfg.username;
      trustedUsers = [ "root" cfg.username "@admin" "@wheel" ];
    };
  };
}
