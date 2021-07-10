#####################################################
# NixOS-specific `command-not-found` configuration. #
#####################################################
{ pkgs, ... }:
{
  programs.command-not-found.enable = false;
}
