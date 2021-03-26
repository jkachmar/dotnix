#############################
# OS-agnostic system tools. #
#############################
{ lib, pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    # Misc. common programs without a better place to go.
    curl
    libvterm-neovim
    vim
    wget

    # TODO: Move this into its own module so each shell can be appropriately
    # configured if it is enabled.
    # nix-index
  ];

  primary-user.home-manager.home.packages = with pkgs; [
    # Misc. common programs without a better place to go.
    bat
    fd
    findutils
    htop
    mosh
    nix-index
    ripgrep
    shellcheck
  ];
}
