{ ... }:
{
  imports = [
    # Base configuration modules for all NixOS systems.
    ./base.nix
    # System configuration modules.
    ../../config/system/fonts.nix
    # XXX: Contains NVIDIA-specific config.
    ../../config/system/nixos/virtualization.nix
    # Security configuration modules.
    ../../config/security/fail2ban.nix
    ../../config/security/gpg.nix
    # Shell configuration modules.
    ../../config/shell/alacritty.nix
    ../../config/shell/bash.nix
    ../../config/shell/htop.nix
    ../../config/shell/fish/nixos.nix
    ../../config/shell/starship.nix
    ../../config/shell/tools/common.nix
    # Desktop configuration modules.
    ../../config/desktop/nixos/applications.nix
    ../../config/desktop/nixos/gnome.nix
    ../../config/desktop/nixos/sound.nix
    ../../config/desktop/nixos/xdg.nix
    ../../config/desktop/nixos/xserver.nix
    # Development configuration modules.
    ../../config/development/direnv.nix
    ../../config/development/neovim
    ../../config/development/vscode.nix
  ];
}
