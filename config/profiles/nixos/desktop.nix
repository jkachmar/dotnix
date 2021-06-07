###########################################
# Generic "desktop" NixOS system profile. #
###########################################
{ ... }:
{
  imports = [
    # Base configuration modules for all NixOS systems.
    ./base.nix
    # Desktop configuration modules.
    ../../modules/desktop/nixos/applications.nix
    ../../modules/desktop/nixos/kde.nix
    ../../modules/desktop/nixos/sound.nix
    # "Data" configuration modules.
    ../../modules/data/git.nix
    # Security configuration modules.
    ../../modules/security/fail2ban.nix
    ../../modules/security/gpg.nix
    ../../modules/security/openssh.nix
    # "UI" configuration modules.
    ../../modules/ui/alacritty.nix
    ../../modules/ui/bash/nixos.nix
    ../../modules/ui/command-not-found.nix
    ../../modules/ui/direnv/nixos.nix
    ../../modules/ui/fish/nixos.nix
    ../../modules/ui/fonts.nix
    ../../modules/ui/htop.nix
    ../../modules/ui/neovim
    ../../modules/ui/vscode/nixos.nix
    ../../modules/ui/starship.nix
  ];
}
