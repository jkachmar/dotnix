{ pkgs, ... }:

let
  ghcideDrv = import (builtins.fetchTarball "https://github.com/cachix/ghcide-nix/archive/67493b873e1a5e5d53837401ab6b128b20e8a989.tar.gz") {};
  ghcide = ghcideDrv.ghcide-ghc883;
in

{
  imports = [
    ./neovim.nix
  ];

  ###############################################################################
  # System-level configuration.
  environment.systemPackages = with pkgs; [
    curl
    git
    nix-prefetch-git
    niv
    vim
    wget
  ];

  ###############################################################################
  # User-level configuration.
  #
  # NOTE: It's important that `pkgs` be taken as an argument here, so that
  # home-manager may install/configure packages based on the user's settings.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [
      cmake
      editorconfig-core-c
      fd
      ghcide
      libvterm-neovim
      mosh
      niv
      ripgrep
      shellcheck
      # sshuttle
    ];

    programs = {
      bat.enable = true;

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      htop.enable = true;

      #########################################################################
      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
        '';
      };

      #########################################################################
      git = {
        enable = true;
        userName = "Joe Kachmar";
        userEmail = "me@jkachmar.com";

        # TODO: Re-enable when GPG Signing is set up
        # signing = {
        #   key = "";
        #   signByDefault = true;
        # };

        extraConfig = {
          alias = {
            st = "status";
          };

          core = {
            editor = "vim";
            pager = "${pkgs.gitAndTools.delta}/bin/delta";
          };
          interactive.diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only";
          delta = {
            line-numbers = true;
            # minus-color = "#340001";
            # plus-color = "#012800";
            syntax-theme = "Monokai Extended";
          };

          color = {
            #   diff = {
            #     meta = "yellow";
            #     frag = "magenta bold";
            #     commit = "yellow bold";
            #     old = "red bold";
            #     new = "green bold";
            #     whitespace = "red reverse";
            #   };

            #   diff-highlight = {
            #     newHighlight = "green bold 22";
            #     newNormal = "green bold";
            #     oldNormal = "red bold";
            #     oldHighlight = "red bold 52";
            #   };

            ui = "always";
          };

          pull.rebase = true;
          push = {
            default = "simple";
            # TODO: Re-enable once GPG signing is back on
            # gpgsign = "if-asked";
          };

          rerere.enabled = true;
        };

        ignores = [
          # Emacs
          "*~"
          "*.*~"
          "\#*"
          ".\#*"

          # Vim
          "*.swp"
          ".*.sw[a-z]"
          "*.un~"
          "Session.vim"
          ".netrwhist"

          # Compiled
          "*.class"
          "*.exe"
          "*.o"
          "*.so"
          "*.dll"
          "*.pyc"

          # Tags (from etags and ctags)
          "TAGS"
          "!TAGS/"
          "tags"
          "!tags/"

          # General
          "*.log"
          "*.cache"
          ".DS_Store?"
          ".DS_Store"
          ".CFUserTextEncoding"
          ".Trash"
          ".Xauthority"
          "thumbs.db"
          "Icon?"
          "Thumbs.db"
          ".cache"
          ".pid"
          ".sock"
        ];
      };

      #########################################################################
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
