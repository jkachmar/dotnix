############################################
# NixOS desktop environment configuration. #
############################################
{ config, pkgs, ... }:
let
  home = config.primary-user.home.directory;
in
{
  primary-user.home-manager.xdg = {
    configFile."user-dirs.locale".text = "en_US";
    userDirs = {
      enable = true;
      desktop = "${home}/desktop";
      documents = "${home}/documents";
      download = "${home}/downloads";
      music = "${home}/music";
      pictures = "${home}/pictures";
      publicShare = "${home}/public";
      templates = "${home}/templates";
      videos = "${home}/videos";
    };
  };
  # XXX: Should the home-manager module just point directly towards the state
  # directory?
  #
  # As it stands, there's maybe a bit _too_ much indirection going on here...
  primary-user.persistence.home.xdg = {
    directories = [
      "desktop"
      "documents"
      "downloads"
      "music"
      "pictures"
      "public"
      "templates"
      "videos"
    ];
  };
}
