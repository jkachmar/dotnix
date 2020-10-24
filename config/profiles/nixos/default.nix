{ inputs, ... }:

{
  imports = [
    # Base modules that the configuration depends upon.
    inputs.home.nixosModules.home-manager
    ../../../modules/primary-user
    # Nix configuration.
    ../../modules/system/nix
    # NixOS-specific 'system' configuration.
    ../../modules/system/nixos/boot
    ../../modules/system/nixos/applications
    ../../modules/system/nixos/miscellaneous
    ../../modules/system/nixos/virtualization
    # Platform-agnostic 'system' configuration.
    ../../modules/system/fonts
    # Platform-agnostic devtool configuration.
    ../../modules/devtools/direnv
    ../../modules/devtools/git
    ../../modules/devtools/neovim
    ../../modules/devtools/shell
  ]
    }
