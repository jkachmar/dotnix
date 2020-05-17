{ ... }:

{
  ###############################################################################
  # User-level configuration.
  #
  # NOTE: It's important that `pkgs` be taken as an argument here, so that
  # home-manager may install/configure packages based on the user's settings.
  primary-user.home-manager = { pkgs, ... }: {
    home.packages = with pkgs; [
      lorri
    ];
    services.lorri.enable = true;

    programs = {
      # These are separate from the common config because darwin needs to have
      # them enabled at the system-level.
      bash.enable = true;
      fish.enable = true;
      zsh.enable = true;

      # Enable emads
      emacs.enable = true;
    };
  };
}
