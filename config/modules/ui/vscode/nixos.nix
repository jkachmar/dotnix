####################################################
# NixOS-specific Visual Studio Code configuration. #
####################################################
{ ... }:
{
  imports = [ ./common.nix ];
  primary-user.persistence.home.misc.directories = [
    ".config/Code"
    ".vscode"
  ];
}
