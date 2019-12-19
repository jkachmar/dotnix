{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./git.nix
    ./fish.nix
    ./htop.nix
    ./mosh.nix
    ./neovim.nix
    ./starship.nix
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
