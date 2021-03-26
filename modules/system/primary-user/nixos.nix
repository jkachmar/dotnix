########################################################################
# NixOS configuration options for the system's primary account holder. #
########################################################################
{ config, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkAliasOptionModule mkDefault mkIf mkMerge mkOption types;
  inherit (lib.options) showOption;
  inherit (pkgs.stdenv.targetPlatform) isLinux;

  cfg = config.primary-user;
in
{
  options.primary-user.persistence.base-directories.global = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = ''
      The base directory for "global" persistent state associated with the
      primary account holder.

      This is state which typically resides under top-level directories such as
      `/etc` or `/var`.
    '';
  };
  options.primary-user.persistence.global =
    let
      suboptions = types.submodule {
        options = {
          directories = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              A list of directories that shall be bind-mounted to paths within
              the given subdirectory of the user's global persistent storage
              directory.
            '';
          };
          files = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              A list of files that shall be symlinked to paths within the
              given subdirectory of the user's global persistent storage
              directory.
            '';
          };
        };
      };
    in
    mkOption {
      default = { };
      type = types.attrsOf suboptions;
      description = ''
        Persistent storage locations for "global" state declared by the primary
        account holder.

        Each attribute should be the relative path to a subdirectory within
        the "global" persistent state directory.
      '';
    };

  options.primary-user.persistence.base-directories.home = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = ''
      The base directory for persistent state associated with the primary
      account holder's personal home directory.

      This is state which typically resides under top-level directories such as
      `/home/alice/.bash_history` or `/home/bob/.config/Signal`.
    '';
  };
  options.primary-user.persistence.home =
    let
      suboptions = types.submodule {
        options = {
          directories = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              A list of directories under the primary user's home directory
              that shall be bind-mounted to paths within the persistent state
              directory.
            '';
          };
          files = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              A list of files under the primary user's home directory that
              shall be symlinked to paths within the persistent state
              directory.
            '';
          };
        };
      };
    in
    mkOption {
      default = { };
      type = types.attrsOf suboptions;
      description = ''
        Persistent storage locations for state within the primary account
        holder's personal home directory.

        Each attribute should be the relative path to a subdirectory within
        the "home" persistent state directory.
      '';
    };

  imports = [
    ../sudo-cmds.nix
    # OS-agnostic option aliases.
    ./common.nix
    # NixOS-specific option aliases.
    (mkAliasOptionModule [ "primary-user" "initialHashedPassword" ] [ "users" "users" cfg.name "initialHashedPassword" ])
    (mkAliasOptionModule [ "primary-user" "extraGroups" ] [ "users" "users" cfg.name "extraGroups" ])
    (mkAliasOptionModule [ "primary-user" "isNormalUser" ] [ "users" "users" cfg.name "isNormalUser" ])
    (mkAliasOptionModule [ "primary-user" "openssh" ] [ "users" "users" cfg.name "openssh" ])
    (mkAliasOptionModule [ "primary-user" "sudo-cmds" ] [ "sudo-cmds" cfg.name ])
  ];

  # Define NixOS-specific `primary-user` configuration.
  config = mkIf (cfg.name != null) (mkMerge [
    # General primary-user configuration settings.
    ({
      users.users.${cfg.name} = {
        name = cfg.name;
        uid = mkDefault 1000;
        home = "/home/${cfg.name}";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      # TODO: Should this use `lib.mkMerge` and _only_ specify the primary user
      # as an allowed and/or trusted user?
      nix = {
        allowedUsers = [ "root" cfg.name ];
        trustedUsers = [ "root" cfg.name ];
      };
    })

    # Persistence for global state associated with the primary account holder.
    (mkIf (cfg.persistence.base-directories.global != null) (
      let
        baseDir = cfg.persistence.base-directories.global;
        subDirs = lib.attrNames cfg.persistence.global;
        mkPersistDirs = subDir: {
          "${baseDir}/${subDir}" = {
            inherit (cfg.persistence.global.${subDir})
              directories
              files;
          };
        };
        persistDirs = builtins.map mkPersistDirs subDirs;
      in
      {
        environment.persistence =
          lib.foldl' lib.recursiveUpdate { } persistDirs;
      }
    ))

    # Persistent state associated with the primary account holder's home
    # directory
    (mkIf (cfg.persistence.base-directories.home != null) (
      let
        baseDir = cfg.persistence.base-directories.home;
        subDirs = lib.attrNames cfg.persistence.home;
        mkPersistDirs = subDir: {
          "${baseDir}/${subDir}" = {
            inherit (cfg.persistence.home.${subDir})
              directories
              files;
            # Allow other users (e.g. root) to access these directories/files.
            allowOther = true;
          };
        };
        persistDirs = builtins.map mkPersistDirs subDirs;
      in
      {
        # Set up the user-level persistent state mount points and allow other
        # users (e.g. root) to access files via the bind-mounted directories.
        programs.fuse.userAllowOther = true;
        primary-user.home-manager.home.persistence =
          lib.foldl' lib.recursiveUpdate { } persistDirs;
      }
    ))
  ]);
}
