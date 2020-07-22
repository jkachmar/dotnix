{ pkgs, ... }:

{
  ###############################################################################
  # User-level configuration.
  primary-user.home-manager = {
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
