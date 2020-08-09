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

      # TODO: Figure out how to get Emacs 27 installed here; the emacs-overly
      # was fucked the last time I tried it out but that's my fault.
      # Enable emacs
      emacs.enable = true;
    };
  };
}
