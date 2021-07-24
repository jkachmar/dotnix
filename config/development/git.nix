####################################
# OS-agnostic `git` configuration. #
####################################
{ config, lib, pkgs, ... }:
let
  delta = pkgs.gitAndTools.delta;
  deltaCmd = "${delta}/bin/delta";
in
{
  primary-user.home-manager.home.packages = [ delta ];
  primary-user.home-manager.programs.git = {
    enable = true;

    # TODO: Re-enable when GPG Signing is set up
    # signing = {
    #   key = "";
    #   signByDefault = true;
    # };

    extraConfig = {
      alias.st = "status";
      core.editor = "vim";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "simple";
      rerere.enabled = true;

      # TODO: Re-enable once GPG signing is back on
      # push.gpgsign = "if-asked";

      core.pager = deltaCmd;
      interactive.diffFilter = "${deltaCmd} --color-only";

      delta = {
        features = "decorations side-by-side unobtrusive-line-numbers";
        navigate = true;

        # 'ansi' does a decent enough job about keeping 'delta' colors in sync
        # with the terminal theme.
        #
        # TODO: Look into toggling between 'light = true' and 'light = false'
        # based on some variable set by the terminal emulator to indicate
        # whether the active theme is light or dark.
        #
        # cf. https://github.com/dandavison/delta/issues/447
        light = true;
        syntax-theme = "ansi";

        # Lifted directly from the 'delta' README.
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
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
}
