###############################################
# OS-agnostic Visual Studio Code configuration. #
#################################################
{ pkgs, unstable, ... }:

{
  primary-user.home-manager = { config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;

      # Copied from `home-manager` source.
      configDir = "Code";
      userDir = if pkgs.stdenv.hostPlatform.isDarwin then
        "Library/Application Support/${configDir}/User"
      else
        "${config.xdg.configHome}/${configDir}/User";
      configFilePath = "${userDir}/settings.json";
    in
    {
      programs.vscode = {
        enable = true;
        package = unstable.vscode;
        # Use up-to-date extensions.
        extensions = (with unstable.vscode-extensions; [
          vadimcn.vscode-lldb
          # TODO: Check out neovim-vscode
          vscodevim.vim
        ]);
      };

      home.file."${configFilePath}".source = 
        mkOutOfStoreSymlink "${config.xdg.configHome}/dotfiles/config/development/vscode/settings.json";
    };
}
