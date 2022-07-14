#################################
# Generic macOS system profile. #
#################################
{ ... }:
{
  imports = [
    # Abstract/configuration-gnostic system modules.
    ../modules/system/primary-user/macos.nix

    # System configuration modules.
    ../config/system/fonts
    ../config/system/macos/brew.nix
    ../config/system/nix/macos.nix
    ../config/system/nixpkgs

    # Security configuration modules.
    ../config/security/ssh-client.nix

    # TODO: These need a revamp...
    # Desktop configuration modules.
    # ../config/desktop/macos/dock.nix
    # ../config/desktop/macos/inputs.nix

    # Development configuration modules.
    ../config/development/bat.nix
    ../config/development/direnv.nix
    ../config/development/git.nix
    ../config/development/neovim
    ../config/development/vscode

    # Shell configuration modules.
    ../config/shell/bash.nix
    ../config/shell/fish/macos.nix
    ../config/shell/htop.nix
    ../config/shell/tools
    ../config/shell/starship.nix
    ../config/shell/tmux.nix
  ];
}
