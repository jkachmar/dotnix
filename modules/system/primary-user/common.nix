##############################################################################
# OS-agnostic configuration options for the system's primary account holder. #
##############################################################################
{ config, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkAliasOptionModule mkIf mkOption types;
  cfg = config.primary-user;
in
{
  options.primary-user.name = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The system primary account holder's username.";
  };

  options.primary-user.email = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The system primary account holder's main email address.";
  };

  # `mkAliasOptionModule` won't work here, as `home-manager` takes a `pkgs`
  # argument which cannot be "mapped over".
  #
  # TODO: See if there isn't a better place to put this sort of thing...
  options.primary-user.git.user.name = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The primary account holder's global git user name.";
  };
  options.primary-user.git.user.email = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The primary account holder's global git email address.";
  };

  # Convenience aliases for various configuration options relating to the
  # system's primary account holder.
  #
  # NOTE: These aliases _must_ be OS-agnostic; this module will be imported by
  # OS-specific modules which will provide the config implementation as well as
  # any additional OS-specific options/aliases.
  imports = [
    # OS-agnostic option aliases.
    (mkAliasOptionModule [ "primary-user" "user" ] [ "users" "users" cfg.name ])
    (mkAliasOptionModule [ "primary-user" "description" ] [ "users" "users" cfg.name "description" ])
    (mkAliasOptionModule [ "primary-user" "home" "directory" ] [ "users" "users" cfg.name "home" ])
    (mkAliasOptionModule [ "primary-user" "uid" ] [ "users" "users" cfg.name "uid" ])
    (mkAliasOptionModule [ "primary-user" "shell" ] [ "users" "users" cfg.name "shell" ])
    # OS-agnostic `home-manager` option aliases.
    (mkAliasOptionModule [ "primary-user" "home-manager" ] [ "home-manager" "users" cfg.name ])
  ];

  config = mkIf (cfg.name != null) {
    home-manager.users.${cfg.name}.programs.git = {
      userName = mkAliasDefinitions options.primary-user.git.user.name;
      userEmail = mkAliasDefinitions options.primary-user.git.user.email;
    };
  };
}
