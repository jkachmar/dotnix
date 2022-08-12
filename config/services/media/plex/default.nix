# 
{ lib, pkgs, ... }:

let
  user = "plexuser";
  group = "plexgroup";
in

{
  # Nginx reverse proxy config is in a separate file because it is too long.
  imports = [ ./nginx.nix ];

  # Create a "plex" user for the service, so a user ID can be manually set.
  #
  # XXX: The NixOS Plex module checks if `services.plex.user == "plex"`, so the
  # custom plex user defined here needs to have a different name.
  #
  # TODO: Manually synchronize the UID and GID with whatever Synology is
  # doing...
  users.users.plexuser = {
    uid = 1001;
    extraGroups = [ "media" ];
    isNormalUser = false;
    isSystemUser = true;
  };
  users.groups.plexgroup.gid = 1002;

  # Ensure that Plex waits for its media to be available.
  systemd.services.plex = {
    after = [ "network.target" "mnt-moodyblues-media.mount" ];
  };

  # XXX: Necessary due to some changes in 21.11.
  users.users.plexuser.group = group;
  services.plex = {
    # XXX: Matches custom Plex user & group used elsewhere.
    inherit user group;

    enable = true;
    dataDir = "/persist/var/lib/plex";
    openFirewall = true;
    package = pkgs.plex.override {
      plexRaw = pkgs.callPackage ./raw.nix { };
    };
  };
}
