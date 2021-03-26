########################################
# Generic "base" NixOS system profile. #
########################################
{ ... }:
{
  imports = [
    # Abstract/configuration-agnostic system modules.
    ../../../modules/system/preLVMTempMount.nix
    ../../../modules/system/primary-user/nixos.nix
    # System configuration modules.
    ../../modules/system/nix/nixos.nix
    ../../modules/system/nixpkgs
    ../../modules/system/systemd-boot.nix
    ../../modules/system/tools/common.nix
    # "Data" configuration modules.
    ../../modules/data/xdg.nix
    # "UI" configuration modules.
    ../../modules/ui/tmux.nix
  ];

  # Mount `/tmp` on a `tmpfs` at boot-time.
  # 
  # XXX: Note that by default this sizes the `tmpfs` partition to 50% of the
  # system memory.
  #
  # cf. https://github.com/NixOS/nixpkgs/issues/23912 for details.
  boot.tmpOnTmpfs = true;
}
