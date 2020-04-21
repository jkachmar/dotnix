{ config, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };
  hardware.opengl.driSupport32Bit = true; # Necessary for NVIDIA support

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ config.primary-user.name ];
}
