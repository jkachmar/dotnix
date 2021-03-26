###################################################
# Machine-agnostic NixOS virtualization settings. #
###################################################
{ config, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # NOTE: Technically not machine-agnostic, since it's for NVIDIA support
  # within VirtualBox.
  hardware.opengl.driSupport32Bit = true;
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ config.primary-user.username ];
}
