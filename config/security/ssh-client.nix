{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;
  inherit (lib) optionalAttrs optionalString;
  username = config.primary-user.name;
in

{
  primary-user.home-manager.programs.ssh = {
    enable = true;
    extraOptionOverrides = optionalAttrs isDarwin {
      IgnoreUnknown = "AddKeysToAgent,UseKeychain";
    };

    extraConfig = optionalString isDarwin ''
      AddKeysToAgent yes
      UseKeychain yes
    '';

    userKnownHostsFile =
      if isDarwin
      then "~/.ssh/known_hosts"
      else "/secrets/openssh/client/${username}/known_hosts";

    # NOTE: lol this is awful, there's gotta be a better way to handle these.
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
      } // optionalAttrs isDarwin {
        identityFile = [ "~/.ssh/id_github" ];
      } // optionalAttrs isLinux {
        identityFile = [ "/secrets/openssh/client/${username}/id_github" ];
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
      } // optionalAttrs isDarwin {
        identityFile = [ "~/.ssh/id_gitlab" ];
      } // optionalAttrs isLinux { };

      "build.stackage.org" = {
        hostname = "build.stackage.org";
      } // optionalAttrs isDarwin {
        identityFile = [ "~/.ssh/id_github" ];
      } // optionalAttrs isLinux { };
    };
  };
}
