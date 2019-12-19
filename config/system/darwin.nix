{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];
    # [ pkgs.vim
    # ];

  # Auto upgrade nix package
  nix.package = pkgs.nix;

  # Create /etc/bashrc and /etc/zshrc that loads the nix-darwin environment
  programs = {
    bash.enable = true;
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
