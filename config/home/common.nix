{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./git.nix
    ./fish.nix
    ./htop.nix
    ./mosh.nix
    ./starship.nix
  ];
}
