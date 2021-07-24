#################################
# Generic macOS system profile. #
#################################
{ ... }:
{
  imports = [
    # Abstract/configuration-gnostic system modules.
    ../modules/system/primary-user/macos.nix
    # System configuration modules.
    ../config/system/macos/brew.nix
    ../config/system/nix/macos.nix
    ../config/system/nixpkgs
    # Security configuration modules.
    ../config/security/ssh-client.nix
    # Desktop configuration modules.
    ../config/desktop/macos/applications.nix
    ../config/desktop/macos/dock.nix
    ../config/desktop/macos/inputs.nix
    # Development configuration modules.
    ../config/development/bat.nix
    ../config/development/direnv.nix
    ../config/development/git.nix
    ../config/development/neovim
    ../config/development/vscode.nix
    # Shell configuration modules.
    ../config/shell/bash.nix
    ../config/shell/fish/macos.nix
    ../config/shell/htop.nix
    ../config/shell/tools
    ../config/shell/starship.nix
    ../config/shell/tmux.nix
  ];
}
