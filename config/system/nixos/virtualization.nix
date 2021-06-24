#######################################
# NixOS virtualization configuration. #
#######################################
{ config, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # TODO: Abstract this out to the `primary-user` config module.
  users.users.jkachmar.extraGroups = [ "docker" ];
}