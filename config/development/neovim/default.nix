###############################################################################
# Neovim configuration.
###############################################################################
{ lib, pkgs, unstable, ... }:

{
  primary-user.home-manager = { config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      # Since Neovim and its plugins are being sourced from 'unstable', the
      # custom plugins should be similarly sourced.
      myPlugins = unstable.callPackage ./plugins.nix { };
    in
    {
      # NOTE: Not that formatter, though; takes forever to comiple.
      # # Lua needs a formatter.
      # home.packages = with pkgs; [ luaformatter ];
      programs.neovim = {
        enable = true;
        # Use neovim-0.5 (only packaged on unstable at the moment).
        package = unstable.neovim-unwrapped;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        withNodeJs = true;
        withPython3 = true;

        # Always pull the latest plugins.
        plugins = with unstable.vimPlugins; with myPlugins; [
          # Language support.
          coc-nvim
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
        # Minimal init.vim config to load Lua config.
        #
        # Nix and Home Manager don't currently support 'init.lua'.
        extraConfig = "lua require('init')";
      };


      # TODO: Abstract this out so it's compatible across NixOS & macOS.
      # xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "/Users/jkachmar/.config/dotfiles/config/development/neovim/lua";
      xdg.configFile."nvim/lua".source =  mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dotfiles/config/development/neovim/lua";
    };
}
