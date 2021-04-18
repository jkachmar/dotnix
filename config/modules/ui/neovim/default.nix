###############################################################################
# Neovim configuration.
###############################################################################
{ lib, pkgs, ... }:

{
  primary-user.home-manager.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      base16-vim
      coc-nvim
      commentary
      direnv-vim
      fugitive
      gitgutter
      haskell-vim
      vim-nix
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
