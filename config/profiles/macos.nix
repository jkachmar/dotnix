#################################
# Generic macOS system profile. #
#################################
{ ... }:
{
  imports = [
    # Abstract/configuration-gnostic system modules.
    ../../modules/system/primary-user/macos.nix
    # System configuration modules.
    ../modules/system/nix/macos.nix
    ../modules/system/nixpkgs
    ../modules/system/tools/macos.nix
    # "Data" configuration modules.
    ../modules/data/git.nix
    # "UI" configuration modules.
    ../modules/ui/bash/common.nix
    ../modules/ui/direnv/common.nix
    ../modules/ui/fish/macos.nix
    ../modules/ui/htop.nix
    ../modules/ui/neovim
    ../modules/ui/starship.nix
    ../modules/ui/tmux.nix
  ];
}
