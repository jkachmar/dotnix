{ config, lib, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkOption types;
  inherit (pkgs.stdenv.targetPlatform) isLinux;
  cfg = config.primary-user;
in
{
  config = lib.mkIf (cfg.username != null && isLinux) {
    primary-user.uid = lib.mkDefault 1000;
    users.users.${cfg.username} = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      name = cfg.username;
    };
    nix.trustedUsers = [ "root" cfg.username ];
  };
}
