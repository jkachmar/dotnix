{ ... }:
{
  imports = [
    # Base configuration modules for all NixOS systems.
    ./base.nix
    # System configuration modules.
    # XXX: Contains NVIDIA-specific config.
    ../../config/system/nixos/virtualization.nix
    # Security configuration modules.
    ../../modules/security/fail2ban.nix
    ../../modules/security/gpg.nix
    # Shell configuration modules.
    ../../config/shell/alacritty.nix
    ../../config/shell/bash.nix
    ../../config/shell/htop.nix
    ../../config/shell/fish/nixos.nix
    ../../config/shell/starship.nix
    ../../config/shell/tools/nixos.nix
    # Desktop configuration modules.
    ../../config/desktop/nixos/applications.nix
    ../../config/desktop/nixos/gnome.nix
    ../../config/desktop/nixos/sound.nix
    # Development configuration modules.
    ../../config/development/direnv.nix
    ../../config/development/neovim
    ../../config/development/vscode.nix
  ];
}