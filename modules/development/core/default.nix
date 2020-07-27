{ lib, pkgs, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux;

  # ghcideDrv = import (builtins.fetchTarball "https://github.com/cachix/ghcide-nix/archive/67493b873e1a5e5d53837401ab6b128b20e8a989.tar.gz") {};
  # ghcide = ghcideDrv.ghcide-ghc883;
in

{
  imports = [
    (if isLinux then ./nixos.nix else ./darwin.nix)
  ];

  ###############################################################################
  # System-level configuration.
  environment.systemPackages = with pkgs; [
    curl
    # ghcide
    git
    # sshuttle
    vim
    wget
  ];

  ###############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    home.packages = with pkgs; [
      fd
      libvterm-neovim
      mosh
      niv
      ripgrep
      shellcheck
    ];

    programs = {
      bat.enable = true;
      htop.enable = true;

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        # 'lorri' is good, but sometimes it breaks, so it's handy to keep this
        # around .
        enableNixDirenvIntegration = true;
      };

      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
        '';
      };

      starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          add_newline = false;
          # git_status can hang on large projects
          git_status.disabled = true;
          # haskell module is very slow for some reason
          haskell.disabled = true;
          line_break.disabled = true;
          username.show_always = true;
        };
      };
    };
  };
}
