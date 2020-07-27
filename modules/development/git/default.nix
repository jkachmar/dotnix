{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = with pkgs; [ gitAndTools.delta ];
    programs.git = {
      enable = true;
      userName = config.primary-user.fullname;
      userEmail = config.primary-user.email;

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
  };
}
