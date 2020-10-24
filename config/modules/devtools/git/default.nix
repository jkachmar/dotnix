{ config, lib, pkgs, ... }:

{
  primary-user.home-manager = {
    programs.git = {
      enable = true;
      package = pkgs.unstable.git;

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

        delta = {
          features = "unobtrusive-line-numbers decorations";

          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-style = "bold yellow ul";
            file-decoration-style = "none";
            hunk-header-decoration-style = "yellow box";
            minus-color = "#012800";
            plus-color = "#340001";
            syntax-theme = "Monokai Extended";
          };

          unobtrusive-line-numbers = {
            line-numbers = true;
            line-numbers-minus-style = "#444444";
            line-numbers-zero-style = "#444444";
            line-numbers-plus-style = "#444444";
            line-numbers-left-format = "{nm:>4}┊";
            line-numbers-right-format = "{np:>4}│";
            line-numbers-left-style = "blue";
            line-numbers-right-style = "blue";
          };
        };

        interactive.diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only";
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
