###############################################
# OS-agnostic Visual Studio Code configuration. #
#################################################
{ pkgs, ... }:

{
  primary-user.home-manager = { config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      programs.vscode.enable = true;
      xdg.configFile."Code/vscode/settings.json".source = 
        mkOutOfStoreSymlink "${config.xdg.configHome}/dotfiles/config/development/vscode/settings.json";
    };
}
