{ inputs, ... }:

{
  imports = [
    # Base modules that the configuration depends upon.
    ../../../modules/primary-user
    # Nix configuration.
    ../../modules/system/nix
    # macOS-specific 'system' configuration.
    ../../modules/system/macOS/miscellaneous
    # Platform-agnostic 'system' configuration.
    ../../modules/system/fonts
    # Platform-agnostic devtool configuration.
    ../../modules/devtools/direnv
    ../../modules/devtools/git
    ../../modules/devtools/neovim
    ../../modules/devtools/shell
  ];
}
