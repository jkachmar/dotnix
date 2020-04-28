{ pkgs, ... }:

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
      mosh
      niv
      ripgrep
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
          pull.rebase = true;
          color.ui = "auto";
          push = {
            default = "simple";
            # TODO: Re-enable once GPG signing is back on
            # gpgsign = "if-asked";
          };

          # TODO: Update as necessary, these were lifted directly from cprussin
          alias = {
            tree = "\"log --all --graph --pretty=format:'%C(yellow)%h %C(cyan)%ai (%ar) %Cred%d%Creset\\n        %C(bold)%an <%ae>%Creset\\n        %s\\n'\"";
            alias = "\"!git config --list | grep 'alias\\\\.' | sed 's/alias\\\\.\\\\([^=]*\\\\)=\\\\(.*\\\\)/\\\\1\\\\\t => \\\\2/' | sort\"";
            merge-log = "\"!f() { git log --stat \\\"\$1^..\$1\\\"; }; f\"";
          };
        };
      };

      #########################################################################
      starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          add_newline = false;
          # git_status can hang on large projects
          git_status.disabled = true;
          line_break.disabled = true;
          username.show_always = true;
        };
      };
    };
  };
}
