{ pkgs, ... }:

let
  gcoreutils = pkgs.coreutils.override {
    singleBinary = false;
    withPrefix = true;
  };

in

{
  imports = [
    ./lorri.nix
  ];

  ###############################################################################
  # System-level configuration.
  environment.systemPackages = with pkgs; [ gcoreutils ];

  programs = {
    bash.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  fonts = {
    enableFontDir = true;
    fonts = [
      pkgs.emacs-all-the-icons-fonts
      pkgs.hack-font
      pkgs.fira-code
    ];
  };

  ###############################################################################
  # User-level configuration.
  #
  # NOTE: It's important that `pkgs` be taken as an argument here, so that
  # home-manager may install/configure packages based on the user's settings.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [
      coreutils
      emacs
      findutils
      gawk
      gnugrep
      gnused
    ];

    # Fixes a bug where fish shell doesn't properly set up the nix path on macOS.
    programs.fish.shellInit = ''
      for p in /run/current-system/sw/bin ~/.nix-profile/bin
        if not contains $p $fish_user_paths
          set -g fish_user_paths $p $fish_user_paths
        end
      end
    '';
  };
}
