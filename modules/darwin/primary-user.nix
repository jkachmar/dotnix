{ config, lib, ... }:

let
  cfg = config.primary-user;
in

{
  options.primary-user.name = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The name of the primary user account.";
  };

  imports = [
    (lib.mkAliasOptionModule [ "primary-user" "description" ] [ "users" "users" cfg.name "description" ])
    (lib.mkAliasOptionModule [ "primary-user" "home" ] [ "users" "users" cfg.name "home" ])
    (lib.mkAliasOptionModule [ "primary-user" "home-manager" ] [ "home-manager" "users" cfg.name ])
    (lib.mkAliasOptionModule [ "primary-user" "shell" ] [ "users" "users" cfg.name "shell" ])
    (lib.mkAliasOptionModule [ "primary-user" "uid" ] [ "users" "users" cfg.name "uid" ])
  ];

  config = lib.mkIf (cfg.name != null) {
    primary-user = {
      uid = lib.mkDefault 1000;
    };
    users.users.${cfg.name}.name = cfg.name;
    nix.trustedUsers = [ "root" cfg.name "@admin" "@wheel" ];
  };
}
