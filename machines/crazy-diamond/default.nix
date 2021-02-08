{ pkgs, ... }:

let
  inherit (pkgs) lib;
in
{
  imports = [
    ./hardware.nix
    ../../profiles/macos.nix
  ];

  primary-user.email = "me@jkachmar.com";
  primary-user.fullname = "Joe Kachmar";
  primary-user.username = "jkachmar";
  networking.hostName = "crazy-diamond";

  #############################################################################
  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
