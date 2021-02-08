###############################################################################
# macOS machihne-agnostic platform configuration.
###############################################################################
{ ... }:

{
  imports = [
    # Custom `nix-darwin` modules.
    ../modules/primary-user
    # macOS-specific configuration.
    ../config/macos
    # Platform-agnostic configuration.
    ../config/fonts
    ../config/git
    ../config/neovim
    ../config/nix
    ../config/shell
  ];
}
