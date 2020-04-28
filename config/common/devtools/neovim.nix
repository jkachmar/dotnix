{ ... }:

{
  ###############################################################################
  # User-level configuration.
  #
  # NOTE: It's important that `pkgs` be taken as an argument here, so that
  # home-manager may install/configure packages based on the user's settings.
  primary-user.home-manager = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      configure = {
        plug.plugins = with pkgs.vimPlugins; [
          direnv-vim
          gruvbox-community
          fugitive
          vim-gitgutter
          vim-nix
        ];

        customRC = ''
          " Color scheme
          "-------------------------
          set background=dark
          colorscheme gruvbox
          let g:gruvbox_contrast_dark='hard'

          set encoding=utf-8

          set nocompatible
          set clipboard=unnamed

          " General Stuff
          "-------------------------
          filetype plugin indent on
          set backspace=indent,eol,start
          set number                     " Show line numbers.
          set cmdheight=1                " Number of screen lines to use for the command line.
          set expandtab                  " Always expand tabs to spaces.
          set linebreak                  " Don't cut lines in the middle of a word.
          set showmatch                  " Highlight matching enclosures.
          syntax enable                  " Enable syntax highlighting.

          " Search
          set incsearch  " Incremental search.
          set ignorecase " Case insensitive.
          set smartcase  " Case sensitive _only_ when there's an uppercase character.
        '';
      };
    };
  };
}
