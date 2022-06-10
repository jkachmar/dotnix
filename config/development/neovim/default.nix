###############################################################################
# Neovim configuration.
###############################################################################
{ lib, pkgs, unstable, ... }:

{
  primary-user.home-manager = { config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      myPlugins = pkgs.callPackage ./plugins.nix { };
    in
    {
      # NOTE: Not that formatter, though; takes forever to comiple.
      # # Lua needs a formatter.
      # home.packages = with pkgs; [ luaformatter ];
      programs.neovim = {
        enable = true;
        package = pkgs.neovim-unwrapped;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        withNodeJs = true;
        withPython3 = true;

        # Always pull the latest plugins.
        plugins = with pkgs.vimPlugins; with myPlugins; [
          # Language support.
          haskell-vim
          vim-nix
          # UI.
          everforest
          gruvbox-material
          lightline-vim
          nvim-base16
          oceanic-next
          # Misc. tooling.
          commentary
          direnv-vim
          # Version control.
          fugitive
          gitgutter
        ];
        # NOTE: Workaround for an issue that has been fixed in unstable but
        # not yet backported (at the time of writing).
        #
        # cf. https://github.com/NixOS/nixpkgs/issues/176753#issuecomment-1148939386=
        configure.packages.myVimPackages.opt = with pkgs.vimPlugins; [ coc-nvim ];

        # XXX: Something's broken; probably an interaction between 'neovim-0.5'
        # (from 'unstable' nixpkgs) and the home-manager modules (which assume
        # stable nixpkgs).

        # Minimal init.vim config to load Lua config.
        #
        # Nix and Home Manager don't currently support 'init.lua'.
        extraConfig = "lua require('init')";
      };


      # TODO: Abstract this out so it's compatible across NixOS & macOS.
      # xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "/Users/jkachmar/.config/dotfiles/config/development/neovim/lua";
      xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dotfiles/config/development/neovim/lua";
    };
}
