########################################
# Generic "base" NixOS system profile. #
########################################
{ ... }:
{
  imports = [
    # Abstract/configuration-agnostic system modules.
    ../../modules/system/preLVMTempMount.nix
    ../../modules/system/primary-user/nixos.nix
    # System configuration modules.
    ../../config/system/nix/nixos.nix
    ../../config/system/nixpkgs
    ../../config/system/nixos/systemd-boot.nix
    # Security configuration modules.
    ../../config/security/openssh.nix
    # Shell configuration modules.
    ../../config/shell/bash.nix
    ../../config/shell/htop.nix
    ../../config/shell/tmux.nix
    ../../config/shell/tools/common.nix
    # Development configuration modules.
    ../../config/development/git.nix
  ];

  # Mount `/tmp` on a `tmpfs` at boot-time.
  # 
  # XXX: Note that by default this sizes the `tmpfs` partition to 50% of the
  # system memory.
  #
  # cf. https://github.com/NixOS/nixpkgs/issues/23912 for details.
  boot.tmpOnTmpfs = true;
}
