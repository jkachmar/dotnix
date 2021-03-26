########################################
# NixOS-specific `gnupg` configuration #
########################################
{ config, lib, pkgs, ... }:
let
  inherit (lib) optionalString;
  isFishEnabled = config.primary-user.home-manager.programs.fish.enable;
in
{
  primary-user.home-manager = { config, ... }:
    let inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      home.packages = [ pkgs.gnupg ];

      # XXX: cf. https://github.com/nix-community/home-manager/issues/1816
      programs.fish.shellInit = optionalString isFishEnabled ''
        set -x GPG_TTY (tty)
      '';

      services.gpg-agent = {
        enable = true;
        # enableSshSupport = true;
        # TODO: Make this conditional on desktop environemnt (maybe).
        pinentryFlavor = "qt";
      };
    };
}
