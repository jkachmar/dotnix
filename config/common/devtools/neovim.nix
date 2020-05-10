{ ... }:

{
  ###############################################################################
  # User-level configuration.
  #
  # NOTE: It's important that `pkgs` be taken as an argument here, so that
  # home-manager may install/configure packages based on the user's settings.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [ nodejs ]; # required by coc
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
          gitgutter
          haskell-vim
          fugitive
          vim-nix
        ];

        customRC = ''
          " Color scheme
          "-------------------------
          set background=dark
          set termguicolors
          colorscheme base16-gruvbox-dark-hard

          set encoding=utf-8

          set nocompatible
          set clipboard=unnamed

          " General Stuff
          "-------------------------
          filetype plugin indent on
          set backspace=indent,eol,start
          set number                     " Show line numbers.
          set cmdheight=2                " Number of screen lines to use for the command line.
          set linebreak                  " Don't cut lines in the middle of a word.
          set showmatch                  " Highlight matching enclosures.
          set smartindent
          set tabstop=4
          set shiftwidth=4
          set expandtab                  " Always expand tabs to spaces.
          syntax enable                  " Enable syntax highlighting.

          " Search
          set incsearch  " Incremental search.
          set ignorecase " Case insensitive.
          set smartcase  " Case sensitive _only_ when there's an uppercase character.

          " haskell-vim settings
          let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
          let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
          let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
          let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
          let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
          let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
          let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
        '';
      };
    };
    xdg.configFile."nvim/coc-settings.json".text = ''
      {
        "languageserver": {
          "haskell": {
            "command": "ghcide",
            "args": [
              "--lsp"
            ],
            "rootPatterns": [
              ".stack.yaml",
              ".hie-bios",
              "BUILD.bazel",
              "cabal.config",
              "package.yaml"
            ],
            "filetypes": [
              "hs",
              "lhs",
              "haskell"
            ]
          }
        }
      }
    '';
  };
}
