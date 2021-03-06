# 
{ lib, pkgs, ... }:

{
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

  services.plex = {
    enable = true;
    dataDir = "/persist/var/lib/plex";
    user = "plexuser"; # XXX: Matches custom Plex user defined below.
    group = "plexgroup"; # XXX: Matches custom Plex group defined below.
    openFirewall = true;
    # XXX: Keep up-to-date with:
    #
    # https://plex.tv/api/downloads/5.json?channel=plexpass
    #
    # TODO: Adapt a more automatic solution with a script:
    #
    # https://github.com/tadfisher/flake/blob/a947b381fc7fb48aa22c29ac4e7149e9f46a9a85/pkgs/plex-plexpass/update.sh
    package = pkgs.plex.override {
      plexRaw = pkgs.callPackage ./raw.nix {};
    };
  };
}
