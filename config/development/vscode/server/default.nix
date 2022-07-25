###############################################
# OS-agnostic Visual Studio Code configuration. #
#################################################
{ pkgs, unstable, ... }:

{
  primary-user.home-manager = { config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;

      # Copied from `home-manager` source.
      configFilePath =
        "${config.xdg.configHome}/Code/User/settings.json";

      # Extension config shared w/ client machines.
      sharedExtensions = unstable.callPackage ../extensions.nix {};

      # Server-only extensions.
      extensions = sharedExtensions ++ (with unstable.vscode-extensions; [
        ms-vscode-remote.remote-ssh
      ]);
    in

    {
      programs.vscode = {
        enable = true;
        package = unstable.vscode;
        inherit extensions;
      };

      home.file."${configFilePath}".source =
        mkOutOfStoreSymlink "${config.xdg.configHome}/dotfiles/config/development/vscode/server/settings.json";
    };
}
