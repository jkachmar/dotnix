###############################################
# OS-agnostic Visual Studio Code configuration. #
#################################################
{ pkgs, ... }:

{
  primary-user.home-manager.programs.vscode = {
    enable = true;
  };
}
