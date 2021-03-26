###############################################################################
# Neovim configuration.
###############################################################################
{ lib, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = with pkgs; [
      nodejs # Required by `coc`.
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      configure = {
        plug.plugins = with pkgs.vimPlugins; [
          base16-vim
          coc-nvim
          commentary
          direnv-vim
          fugitive
          gitgutter
          haskell-vim
          vim-nix
        ];
        customRC = builtins.readFile ./vimrc;
      };
    };
  };
}
