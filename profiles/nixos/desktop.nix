{ ... }:
{
  imports = [
    # Base configuration modules for all NixOS systems.
    ./base.nix
    # System configuration modules.
    ../../config/system/fonts
    # XXX: Contains NVIDIA-specific config.
    ../../config/system/nixos/docker.nix
    # Security configuration modules.
    ../../config/security/gpg.nix
    # Shell configuration modules.
    ../../config/shell/alacritty.nix
    ../../config/shell/bash.nix
    ../../config/shell/htop.nix
    ../../config/shell/fish/nixos.nix
    ../../config/shell/starship.nix
    # Desktop configuration modules.
    ../../config/desktop/nixos/applications.nix
    ../../config/desktop/nixos/gnome.nix
    ../../config/desktop/nixos/sound.nix
    ../../config/desktop/nixos/xdg.nix
    ../../config/desktop/nixos/xserver.nix
    # Development configuration modules.
    ../../config/development/bat.nix
    ../../config/development/direnv.nix
    ../../config/development/neovim
    ../../config/development/vscode
  ];
}
