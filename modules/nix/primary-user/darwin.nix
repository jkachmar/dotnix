{ config, lib, ... }:

let
  cfg = config.primary-user;
in

{
  options.primary-user.fullname = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The full name of the primary user.";
  };

  options.primary-user.username = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The name of the primary user account.";
  };

  imports = [
    (lib.mkAliasOptionModule [ "primary-user" "description" ] [ "users" "users" cfg.username "description" ])
    (lib.mkAliasOptionModule [ "primary-user" "home" ] [ "users" "users" cfg.username "home" ])
    (lib.mkAliasOptionModule [ "primary-user" "home-manager" ] [ "home-manager" "users" cfg.username ])
    (lib.mkAliasOptionModule [ "primary-user" "shell" ] [ "users" "users" cfg.username "shell" ])
    (lib.mkAliasOptionModule [ "primary-user" "uid" ] [ "users" "users" cfg.username "uid" ])
  ];

  config = lib.mkIf (cfg.username != null) {
    primary-user = {
      uid = lib.mkDefault 1000;
    };
    users.users.${cfg.username}.name = cfg.username;
    nix.trustedUsers = [ "root" cfg.username "@admin" "@wheel" ];
  };
}
