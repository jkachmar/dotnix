{ config, lib, options, ... }:
let
  inherit (lib) mkAliasDefinitions mkOption types;
  cfg = config.primary-user;
in
{
  options.primary-user.email = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The primary user's email address.";
  };

  options.primary-user.fullname = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The primary user's \"full name\".";
  };

  options.primary-user.username = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "The primary user's account name (username).";
  };

  # Convenience aliases for various configuration options relating to the
  # primary user of a given machine.

  options.primary-user.home-manager = mkOption {
    type = options.home-manager.users.type.functor.wrapped;
  };
  config.home-manager.users.${cfg.username} =
    mkAliasDefinitions options.primary-user.home-manager;

  options.primary-user.user = mkOption {
    type = options.users.users.type.functor.wrapped;
  };
  config.users.users.${cfg.username} =
    mkAliasDefinitions options.primary-user.user;

  options.primary-user.packages = mkOption {
    type = types.listOf types.package;
  };
  config.primary-user.user.packages =
    mkAliasDefinitions options.primary-user.packages;

  options.primary-user.description = mkOption {
    type = types.nullOr types.string;
  };
  config.primary-user.user.description =
    mkAliasDefinitions options.primary-user.description;

  options.primary-user.shell = mkOption {
    type = types.either types.shellPackages types.path;
  };
  config.primary-user.user.shell =
    mkAliasDefinitions options.primary-user.shell;

  options.primary-user.uid = mkOption {
    type = types.nullOr types.int;
  };
  config.primary-user.user.uid =
    mkAliasDefinitions options.primary-user.uid;

  imports = [ ./macos.nix ./nixos.nix ];
}
