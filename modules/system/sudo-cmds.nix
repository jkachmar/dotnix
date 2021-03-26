########################################################
# Per-command passwordless sudo configuration options. #
########################################################
{ config, lib, pkgs, ... }:
let
  inherit (lib) mapAttrsToList mkAfter mkOption types;
  inherit (pkgs.stdenv.targetPlatform) isLinux;

  cfg = config.sudo-cmds;

  nopasswd = command: {
    inherit command;
    options = [ "NOPASSWD" ];
  };
in
{
  options.sudo-cmds = mkOption {
    type = types.attrsOf (types.listOf types.str);
    default = { };
    description = ''
      An attrset mapping usernames to lists of sudo commands to allow those
      users to run without passwords.
    '';
  };
  config.security.sudo.extraRules = mkAfter (
    mapAttrsToList
      (
        username: commands: {
          users = [ username ];
          commands = map nopasswd commands;
        }
      )
      cfg
  );
}
